//
//  CacheWorker.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-15.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

public struct DataWorker: DataWorkerType, Loggable {
    private static let queue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).DataWorker.sync")
    
    private let seedStore: SeedStore
    private let syncStore: SyncStore
    private let cacheStore: CacheStore
    
    init(seedStore: SeedStore, syncStore: SyncStore, cacheStore: CacheStore) {
        self.seedStore = seedStore
        self.syncStore = syncStore
        self.cacheStore = cacheStore
    }
}

public extension DataWorker {
    // Ensure one configuration request at a time
    private static var isConfiguring = false
    
    func configure() {
        DataWorker.queue.sync {
            guard !DataWorker.isConfiguring else { return }
            DataWorker.isConfiguring = true
            
            self.seedStore.configure()
            self.syncStore.configure()
            self.cacheStore.configure()
            
            DataWorker.isConfiguring = false
        }
    }
}

public extension DataWorker {
    // Handle simultanuous pull requests in a queue
    private static var tasks = [((Result<SeedPayloadType, DataError>) -> Void)]()
    private static var isSyncing = false
    
    func sync(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        Log(info: "Cache sync requested.")
        
        DataWorker.queue.async {
            DataWorker.tasks.append(completion)
            
            guard !DataWorker.isSyncing else { return }
            DataWorker.isSyncing = true
            
            // Handler will be called later by multiple code paths
            func deferredTask(_ result: Result<SeedPayloadType, DataError>) {
                DataWorker.queue.async {
                    let tasks = DataWorker.tasks
                    DataWorker.tasks.removeAll()
                    DataWorker.isSyncing = false
                    
                    self.Log(info: "Cache sync complete and now executing \(tasks.count) queued tasks...")
                    
                    DispatchQueue.main.async {
                        tasks.forEach { $0(result) }
                    }
                }
            }
        
            // Determine if cache seeded before or just get latest from remote
            guard let lastSyncedAt = self.cacheStore.lastSyncedAt else {
                self.Log(info: "Seeding cache storage begins...")
                
                self.seedStore.fetch {
                    guard case .success(let value) = $0 else {
                        deferredTask($0)
                        return
                    }
                    
                    self.Log(debug: "Found \(value.posts.count) posts to seed into cache storage.")
                    let date = value.posts.map { $0.modifiedAt }.max() ?? Date()
                    
                    self.cacheStore.createOrUpdate(value, lastSyncedAt: date) {
                        deferredTask($0)
                        
                        // Cache seeded now re-sync
                        guard case .success = $0 else { return }
                        self.Log(debug: "Seeding cache storage complete, now syncing with remote storage.")
                        self.sync(completion: completion)
                    }
                }
                
                return
            }
            
            self.Log(info: "Sync cache storage begins, last synced at \(lastSyncedAt)...")
            let date = Date()
            
            self.syncStore.fetchModified(after: lastSyncedAt) {
                guard case .success(let value) = $0 else {
                    deferredTask($0)
                    return
                }
                
                self.Log(debug: "Found \(value.posts.count) posts to sync with cache storage.")
                self.cacheStore.createOrUpdate(value, lastSyncedAt: date, completion: deferredTask)
            }
        }
    }
}
