//
//  CacheWorker.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-15.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

public struct DataWorker: DataWorkerType, Loggable {
    private let constants: ConstantsType
    private let seedStore: SeedStore
    private let remoteStore: RemoteStore
    private let cacheStore: CacheStore
    
    init(constants: ConstantsType, seedStore: SeedStore, remoteStore: RemoteStore, cacheStore: CacheStore) {
        self.constants = constants
        self.seedStore = seedStore
        self.remoteStore = remoteStore
        self.cacheStore = cacheStore
    }
}

public extension DataWorker {
    
    func configure() {
        seedStore.configure()
        remoteStore.configure()
        cacheStore.configure()
    }
    
    func resetCache(for userID: Int) {
        cacheStore.delete(for: userID)
    }
}

public extension DataWorker {
    // Handle simultanuous pull requests in a queue
    private static let queue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).DataWorker.sync")
    private static var tasks = [((Result<SeedPayloadType, DataError>) -> Void)]()
    private static var isPulling = false
    
    func pull(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        DataWorker.queue.async {
            DataWorker.tasks.append(completion)
            
            guard !DataWorker.isPulling else {
                self.Log(info: "Data pull already in progress, queuing...")
                return
            }
            
            DataWorker.isPulling = true
            self.Log(info: "Data pull requested...")
        
            // Determine if cache seeded before or just get latest from remote
            guard let lastPulledAt = self.cacheStore.lastPulledAt else {
                self.Log(info: "Seeding cache storage first time begins...")
                self.seedFromLocal()
                return
            }
            
            self.Log(info: "Pull remote into cache storage begins, last pulled at \(lastPulledAt)...")
            self.seedFromRemote(after: lastPulledAt)
        }
    }
    
    private func seedFromRemote(after date: Date) {
        let request = DataStoreModels.ModifiedRequest(
            taxonomies: constants.taxonomies,
            postMetaKeys: constants.postMetaKeys,
            limit: nil
        )
        
        remoteStore.fetchModified(after: date, with: request) {
            guard case .success(let value) = $0 else {
                self.executeTasks($0)
                return
            }
            
            self.Log(debug: "Found \(value.posts.count) posts to remotely pull into cache storage.")
            
            let request = DataStoreModels.CacheRequest(payload: value, lastPulledAt: Date())
            self.cacheStore.createOrUpdate(with: request, completion: self.executeTasks)
        }
    }
    
    private func seedFromLocal() {
        seedStore.fetch {
            guard case .success(let local) = $0, !local.isEmpty else {
                self.Log(error: "Failed to retrieve seed data, falling back to remote server...")
                
                let request = DataStoreModels.ModifiedRequest(
                    taxonomies: self.constants.taxonomies,
                    postMetaKeys: self.constants.postMetaKeys,
                    limit: self.constants.defaultFetchModifiedLimit
                )
                
                self.remoteStore.fetchModified(after: nil, with: request) {
                    guard case .success(let value) = $0 else {
                        self.executeTasks($0)
                        return
                    }
                    
                    self.Log(debug: "Found \(value.posts.count) posts to remotely pull into cache storage.")
                    
                    let request = DataStoreModels.CacheRequest(payload: value, lastPulledAt: Date())
                    self.cacheStore.createOrUpdate(with: request, completion: self.executeTasks)
                }
                
                return
            }
            
            self.Log(debug: "Found \(local.posts.count) posts to seed into cache storage.")
            
            let lastSeedDate = local.posts.map { $0.modifiedAt }.max() ?? Date()
            let request = DataStoreModels.CacheRequest(payload: local, lastPulledAt: lastSeedDate)
            
            self.cacheStore.createOrUpdate(with: request) {
                guard case .success = $0 else {
                    self.executeTasks($0)
                    return
                }
                
                self.Log(debug: "Seeding cache storage complete, now pulling from remote storage.")
                
                // Fetch latest beyond seed
                let request = DataStoreModels.ModifiedRequest(
                    taxonomies: self.constants.taxonomies,
                    postMetaKeys: self.constants.postMetaKeys,
                    limit: nil
                )
                
                self.remoteStore.fetchModified(after: lastSeedDate, with: request) {
                    guard case .success(let remote) = $0 else {
                        self.executeTasks(.success(local))
                        return
                    }
                    
                    self.Log(debug: "Found \(remote.posts.count) posts to remotely pull into cache storage.")
                    let request = DataStoreModels.CacheRequest(payload: remote, lastPulledAt: Date())
                    
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
                        
                        self.Log(debug: "Seeded \(local.posts.count) posts from local "
                            + "and \(remote.posts.count) posts from remote into cache storage.")
                        
                        self.executeTasks(.success(combinedSeed))
                    }
                }
            }
        }
    }
    
    private func executeTasks(_ result: Result<SeedPayloadType, DataError>) {
        DataWorker.queue.async {
            let tasks = DataWorker.tasks
            DataWorker.tasks.removeAll()
            DataWorker.isPulling = false
            
            self.Log(info: "Data pull request complete, now executing \(tasks.count) queued tasks...")
            
            DispatchQueue.main.async {
                tasks.forEach { $0(result) }
            }
        }
    }
}
