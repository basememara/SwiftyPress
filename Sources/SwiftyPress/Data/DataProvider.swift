//
//  DataProvider.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-15.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct DataProvider: DataProviderType {
    private let constants: ConstantsType
    private let seedStore: SeedStore
    private let remoteStore: RemoteStore
    private let cacheStore: CacheStore
    private let log: LogProviderType
    
    init(constants: ConstantsType, seedStore: SeedStore, remoteStore: RemoteStore, cacheStore: CacheStore, log: LogProviderType) {
        self.constants = constants
        self.seedStore = seedStore
        self.remoteStore = remoteStore
        self.cacheStore = cacheStore
        self.log = log
    }
}

public extension DataProvider {
    
    func configure() {
        seedStore.configure()
        remoteStore.configure()
        cacheStore.configure()
    }
    
    func resetCache(for userID: Int) {
        cacheStore.delete(for: userID)
    }
}

public extension DataProvider {
    // Handle simultanuous pull requests in a queue
    private static let queue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).DataProvider.sync")
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
            guard let lastPulledAt = self.cacheStore.lastPulledAt else {
                self.log.info("Seeding cache storage first time begins...")
                self.seedFromLocal()
                return
            }
            
            self.log.info("Pull remote into cache storage begins, last pulled at \(lastPulledAt)...")
            self.seedFromRemote(after: lastPulledAt)
        }
    }
    
    private func seedFromRemote(after date: Date) {
        let request = DataAPI.ModifiedRequest(
            taxonomies: constants.taxonomies,
            postMetaKeys: constants.postMetaKeys,
            limit: nil
        )
        
        remoteStore.fetchModified(after: date, with: request) {
            guard case .success(let value) = $0 else {
                self.executeTasks($0)
                return
            }
            
            self.log.debug("Found \(value.posts.count) posts to remotely pull into cache storage.")
            
            let request = DataAPI.CacheRequest(payload: value, lastPulledAt: Date())
            self.cacheStore.createOrUpdate(with: request, completion: self.executeTasks)
        }
    }
    
    private func seedFromLocal() {
        seedStore.fetch {
            guard case .success(let local) = $0, !local.isEmpty else {
                self.log.error("Failed to retrieve seed data, falling back to remote server...")
                
                let request = DataAPI.ModifiedRequest(
                    taxonomies: self.constants.taxonomies,
                    postMetaKeys: self.constants.postMetaKeys,
                    limit: self.constants.defaultFetchModifiedLimit
                )
                
                self.remoteStore.fetchModified(after: nil, with: request) {
                    guard case .success(let value) = $0 else {
                        self.executeTasks($0)
                        return
                    }
                    
                    self.log.debug("Found \(value.posts.count) posts to remotely pull into cache storage.")
                    
                    let request = DataAPI.CacheRequest(payload: value, lastPulledAt: Date())
                    self.cacheStore.createOrUpdate(with: request, completion: self.executeTasks)
                }
                
                return
            }
            
            self.log.debug("Found \(local.posts.count) posts to seed into cache storage.")
            
            let lastSeedDate = local.posts.map { $0.modifiedAt }.max() ?? Date()
            let request = DataAPI.CacheRequest(payload: local, lastPulledAt: lastSeedDate)
            
            self.cacheStore.createOrUpdate(with: request) {
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
                
                self.remoteStore.fetchModified(after: lastSeedDate, with: request) {
                    guard case .success(let remote) = $0 else {
                        self.executeTasks(.success(local))
                        return
                    }
                    
                    self.log.debug("Found \(remote.posts.count) posts to remotely pull into cache storage.")
                    let request = DataAPI.CacheRequest(payload: remote, lastPulledAt: Date())
                    
                    self.cacheStore.createOrUpdate(with: request) {
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
    
    private func executeTasks(_ result: Result<SeedPayloadType, DataError>) {
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
