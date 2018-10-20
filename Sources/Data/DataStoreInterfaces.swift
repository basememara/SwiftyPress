//
//  SeedStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public protocol SeedStore {
    func setup()
    func fetch(completion: @escaping (Result<ModifiedPayload, DataError>) -> Void)
}

public protocol SyncStore {
    func setup()
    func fetchModified(after date: Date, completion: @escaping (Result<ModifiedPayload, DataError>) -> Void)
}

public protocol CacheStore {
    func setup()
    var lastSyncedAt: Date? { get }
    func createOrUpdate(_ request: ModifiedPayload, lastSyncedAt: Date, completion: @escaping (Result<ModifiedPayload, DataError>) -> Void)
    func delete(for userID: Int) throws
}

public protocol DataWorkerType {
    func setup()
    func sync(completion: @escaping (Result<ModifiedPayload, DataError>) -> Void)
}
