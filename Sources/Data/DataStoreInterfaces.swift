//
//  SeedStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public protocol SeedStore {
    func configure()
    func fetch(completion: @escaping (Result<SeedPayload, DataError>) -> Void)
}

public protocol SyncStore {
    func configure()
    func fetchModified(after date: Date, completion: @escaping (Result<SeedPayload, DataError>) -> Void)
}

public protocol CacheStore {
    func configure()
    var lastSyncedAt: Date? { get }
    func createOrUpdate(_ request: SeedPayload, lastSyncedAt: Date, completion: @escaping (Result<SeedPayload, DataError>) -> Void)
    func delete(for userID: Int) throws
}

public protocol DataWorkerType {
    func configure()
    func sync(completion: @escaping (Result<SeedPayload, DataError>) -> Void)
}
