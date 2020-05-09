//
//  DataRepository.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-15.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct DataRepository: DataRepositoryType {
    private let seedService: SeedService
    private let remoteService: RemoteService
    private let cacheService: CacheService
    private let constants: ConstantsType
    private let log: LogRepository
    
    init(
        seedService: SeedService,
        remoteService: RemoteService,
        cacheService: CacheService,
        constants: ConstantsType,
        log: LogRepository
    ) {
        self.seedService = seedService
        self.remoteService = remoteService
        self.cacheService = cacheService
        self.constants = constants
        self.log = log
    }
}

public extension DataRepository {
    
    func configure() {
        seedService.configure()
        remoteService.configure()
        cacheService.configure()
    }
    
    func resetCache(for userID: Int) {
        cacheService.delete(for: userID)
    }
}

public extension DataRepository {
    // Handle simultanuous pull requests in a queue
    private static let queue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).DataRepository.pull")
    private static var tasks = [((Result<SeedPayloadType, DataError>) -> Void)]()
    private static var isPulling = false
    
    func pull(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        Self.queue.async {
            Self.tasks.append(completion)
            
            guard !Self.isPulling else {
                self.log.info("Data pull already in progress, queuing...")
                return
            }
            
            Self.isPulling = true
            self.log.info("Data pull requested...")
        
            // Determine if cache seeded before or just get latest from remote
            guard let lastPulledAt = self.cacheService.lastPulledAt else {
                self.log.info("Seeding cache storage first time begins...")
                self.seedFromLocal()
                return
            }
            
            self.log.info("Pull remote into cache storage begins, last pulled at \(lastPulledAt)...")
            self.seedFromRemote(after: lastPulledAt)
        }
    }
}

private extension DataRepository {
    
    func seedFromRemote(after date: Date) {
        let request = DataAPI.ModifiedRequest(
            taxonomies: constants.taxonomies,
            postMetaKeys: constants.postMetaKeys,
            limit: nil
        )
        
        remoteService.fetchModified(after: date, with: request) {
            guard case .success(let value) = $0 else {
                self.executeTasks($0)
                return
            }
            
            self.log.debug("Found \(value.posts.count) posts to remotely pull into cache storage.")
            
            let request = DataAPI.CacheRequest(payload: value, lastPulledAt: Date())
            self.cacheService.createOrUpdate(with: request, completion: self.executeTasks)
        }
    }
}

private extension DataRepository {
    
    func seedFromLocal() {
        seedService.fetch {
            guard case .success(let local) = $0, !local.isEmpty else {
                self.log.error("Failed to retrieve seed data, falling back to remote server...")
                
                let request = DataAPI.ModifiedRequest(
                    taxonomies: self.constants.taxonomies,
                    postMetaKeys: self.constants.postMetaKeys,
                    limit: self.constants.defaultFetchModifiedLimit
                )
                
                self.remoteService.fetchModified(after: nil, with: request) {
                    guard case .success(let value) = $0 else {
                        self.executeTasks($0)
                        return
                    }
                    
                    self.log.debug("Found \(value.posts.count) posts to remotely pull into cache storage.")
                    
                    let request = DataAPI.CacheRequest(payload: value, lastPulledAt: Date())
                    self.cacheService.createOrUpdate(with: request, completion: self.executeTasks)
                }
                
                return
            }
            
            self.log.debug("Found \(local.posts.count) posts to seed into cache storage.")
            
            let lastSeedDate = local.posts.map { $0.modifiedAt }.max() ?? Date()
            let request = DataAPI.CacheRequest(payload: local, lastPulledAt: lastSeedDate)
            
            self.cacheService.createOrUpdate(with: request) {
                guard case .success = $0 else {
                    self.executeTasks($0)
                    return
                }
                
                self.log.debug("Seeding cache storage complete, now pulling from remote storage.")
                
                // Fetch latest beyond seed
                let request = DataAPI.ModifiedRequest(
                    taxonomies: self.constants.taxonomies,
                    postMetaKeys: self.constants.postMetaKeys,
                    limit: nil
                )
                
                self.remoteService.fetchModified(after: lastSeedDate, with: request) {
                    guard case .success(let remote) = $0 else {
                        self.executeTasks(.success(local))
                        return
                    }
                    
                    self.log.debug("Found \(remote.posts.count) posts to remotely pull into cache storage.")
                    let request = DataAPI.CacheRequest(payload: remote, lastPulledAt: Date())
                    
                    self.cacheService.createOrUpdate(with: request) {
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
    
    func executeTasks(_ result: Result<SeedPayloadType, DataError>) {
        Self.queue.async {
            let tasks = Self.tasks
            Self.tasks.removeAll()
            Self.isPulling = false
            
            self.log.info("Data pull request complete, now executing \(tasks.count) queued tasks...")
            
            DispatchQueue.main.async {
                tasks.forEach { $0(result) }
            }
        }
    }
}
