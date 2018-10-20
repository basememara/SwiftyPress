//
//  CacheWorker.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-15.
//

import ZamzamKit

public struct DataWorker: DataWorkerType, Loggable {
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
    
    func setup() {
        seedStore.setup()
        syncStore.setup()
        cacheStore.setup()
    }
}

public extension DataWorker {
    // Handle simultanuous pull requests in a queue
    private static let queue = DispatchQueue(label: "\(Bundle.swiftyPress.bundleIdentifier!).DataWorker.sync")
    private static var tasks = [((Result<ModifiedPayload, DataError>) -> Void)]()
    private static var isSyncing = false
    
    func sync(completion: @escaping (Result<ModifiedPayload, DataError>) -> Void) {
        Log(info: "Cache sync requested.")
        
        DataWorker.queue.async {
            DataWorker.tasks.append(completion)
            
            guard !DataWorker.isSyncing else { return }
            DataWorker.isSyncing = true
            
            // Handler will be called later by multiple code paths
            func deferredTask(_ result: Result<ModifiedPayload, DataError>) {
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
                
                return self.seedStore.fetch {
                    guard let value = $0.value, $0.isSuccess else { return deferredTask($0) }
                    let date = value.posts.map { $0.modifiedAt }.max() ?? Date()
                    
                    self.Log(debug: "Found \(value.posts.count) posts to seed into cache storage.")
                    
                    self.cacheStore.createOrUpdate(value, lastSyncedAt: date) {
                        deferredTask($0)
                        
                        // Cache seeded now re-sync
                        guard $0.isSuccess else { return }
                        self.Log(debug: "Seeding cache storage complete, now syncing with remote storage.")
                        self.sync(completion: completion)
                    }
                }
            }
            
            let date = Date()
            
            self.Log(info: "Sync cache storage begins, last synced at \(lastSyncedAt)...")
            
            self.syncStore.fetchModified(after: lastSyncedAt) {
                guard let value = $0.value, $0.isSuccess else { return deferredTask($0) }
                self.Log(debug: "Found \(value.posts.count) posts to sync with cache storage.")
                self.cacheStore.createOrUpdate(value, lastSyncedAt: date, completion: deferredTask)
            }
        }
    }
}
