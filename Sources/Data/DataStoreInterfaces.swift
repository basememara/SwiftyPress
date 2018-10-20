//
//  SeedStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public protocol SeedStore {
    func setup()
    func fetch(completion: @escaping (Result<SeedPayload, DataError>) -> Void)
}

public protocol SyncStore {
    func setup()
    func fetchModified(after date: Date, completion: @escaping (Result<SeedPayload, DataError>) -> Void)
}

public protocol CacheStore {
    func setup()
    var lastSyncedAt: Date? { get }
    func createOrUpdate(_ request: SeedPayload, lastSyncedAt: Date, completion: @escaping (Result<SeedPayload, DataError>) -> Void)
    func delete(for userID: Int) throws
}

public protocol DataWorkerType {
    func setup()
    func sync(completion: @escaping (Result<SeedPayload, DataError>) -> Void)
}
