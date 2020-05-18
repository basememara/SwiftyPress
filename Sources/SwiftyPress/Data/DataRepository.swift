//
//  DataRepository.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-15.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct DataRepository {
    private let dataService: DataService
    private let dataCache: DataCache
    private let dataSeed: DataSeed
    private let constants: Constants
    private let log: LogRepository
    
    init(
        dataService: DataService,
        dataCache: DataCache,
        dataSeed: DataSeed,
        constants: Constants,
        log: LogRepository
    ) {
        self.dataService = dataService
        self.dataCache = dataCache
        self.dataSeed = dataSeed
        self.constants = constants
        self.log = log
    }
}

public extension DataRepository {
    
    func configure() {
        dataCache.configure()
        dataSeed.configure()
    }
    
    func resetCache(for userID: Int) {
        dataCache.delete(for: userID)
    }
}

public extension DataRepository {
    // Handle simultanuous fetch requests in a queue
    private static let queue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).DataRepository.fetch")
    private static var tasks = [((Result<SeedPayload, SwiftyPressError>) -> Void)]()
    private static var isFetching = false
    
    func fetch(completion: @escaping (Result<SeedPayload, SwiftyPressError>) -> Void) {
        Self.queue.async {
            Self.tasks.append(completion)
            
            guard !Self.isFetching else {
                self.log.info("Data fetch already in progress, queuing...")
                return
            }
            
            Self.isFetching = true
            self.log.info("Data fetch requested...")
        
            // Determine if cache seeded before or just get latest from remote
            guard let lastFetchedAt = self.dataCache.lastFetchedAt else {
                self.log.info("Seeding cache storage first time begins...")
                self.refreshFromSeed()
                return
            }
            
            self.log.info("Fetch remote into cache storage begins, last fetched at \(lastFetchedAt)...")
            self.refreshFromService(after: lastFetchedAt)
        }
    }
}

private extension DataRepository {
    
    func refreshFromService(after date: Date) {
        let request = DataAPI.ModifiedRequest(
            taxonomies: constants.taxonomies,
            postMetaKeys: constants.postMetaKeys,
            limit: nil
        )
        
        dataService.fetchModified(after: date, with: request) {
            guard case .success(let item) = $0 else {
                self.executeTasks($0)
                return
            }
            
            self.log.debug("Found \(item.posts.count) posts to remotely fetch into cache storage.")
            
            let request = DataAPI.CacheRequest(payload: item, lastFetchedAt: Date())
            self.dataCache.createOrUpdate(with: request, completion: self.executeTasks)
        }
    }
}

private extension DataRepository {
    
    func refreshFromSeed() {
        dataSeed.fetch {
            guard case .success(let local) = $0, !local.isEmpty else {
                self.log.error("Failed to retrieve seed data, falling back to remote server...")
                
                let request = DataAPI.ModifiedRequest(
                    taxonomies: self.constants.taxonomies,
                    postMetaKeys: self.constants.postMetaKeys,
                    limit: self.constants.defaultFetchModifiedLimit
                )
                
                self.dataService.fetchModified(after: nil, with: request) {
                    guard case .success(let item) = $0 else {
                        self.executeTasks($0)
                        return
                    }
                    
                    self.log.debug("Found \(item.posts.count) posts to remotely fetch into cache storage.")
                    
                    let request = DataAPI.CacheRequest(payload: item, lastFetchedAt: Date())
                    self.dataCache.createOrUpdate(with: request, completion: self.executeTasks)
                }
                
                return
            }
            
            self.log.debug("Found \(local.posts.count) posts to seed into cache storage.")
            
            let lastSeedDate = local.posts.map { $0.modifiedAt }.max() ?? Date()
            let request = DataAPI.CacheRequest(payload: local, lastFetchedAt: lastSeedDate)
            
            self.dataCache.createOrUpdate(with: request) {
                guard case .success = $0 else {
                    self.executeTasks($0)
                    return
                }
                
                self.log.debug("Seeding cache storage complete, now fetching from remote storage.")
                
                // Fetch latest beyond seed
                let request = DataAPI.ModifiedRequest(
                    taxonomies: self.constants.taxonomies,
                    postMetaKeys: self.constants.postMetaKeys,
                    limit: nil
                )
                
                self.dataService.fetchModified(after: lastSeedDate, with: request) {
                    guard case .success(let remote) = $0 else {
                        self.executeTasks(.success(local))
                        return
                    }
                    
                    self.log.debug("Found \(remote.posts.count) posts to remotely fetch into cache storage.")
                    let request = DataAPI.CacheRequest(payload: remote, lastFetchedAt: Date())
                    
                    self.dataCache.createOrUpdate(with: request) {
                        guard case .success = $0 else {
                            self.executeTasks(.success(local))
                            return
                        }
                        
                        let combinedSeed = SeedPayload(
                            posts: local.posts + remote.posts,
                            authors: local.authors + remote.authors,
                            media: local.media + remote.media,
                            terms: local.terms + remote.terms
                        )
                        
                        self.log.debug("Seeded \(local.posts.count) posts from local "
                            + "and \(remote.posts.count) posts from remote into cache storage.")
                        
                        self.executeTasks(.success(combinedSeed))
                    }
                }
            }
        }
    }
}

private extension DataRepository {
    
    func executeTasks(_ result: Result<SeedPayload, SwiftyPressError>) {
        Self.queue.async {
            let tasks = Self.tasks
            Self.tasks.removeAll()
            Self.isFetching = false
            
            self.log.info("Data fetch request complete, now executing \(tasks.count) queued tasks...")
            
            DispatchQueue.main.async {
                tasks.forEach { $0(result) }
            }
        }
    }
}
