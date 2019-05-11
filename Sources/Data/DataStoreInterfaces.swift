//
//  SeedStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

public protocol SeedStore {
    func configure()
    func fetch(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

public protocol SyncStore {
    func configure()
    func fetchModified(after date: Date, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

public protocol CacheStore {
    var lastSyncedAt: Date? { get }
    
    func configure()
    func createOrUpdate(_ request: SeedPayloadType, lastSyncedAt: Date, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
    func delete(for userID: Int) throws
}

public protocol DataWorkerType {
    func configure()
    func sync(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}
