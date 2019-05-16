//
//  SeedStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public protocol SeedStore {
    func configure()
    func fetch(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

public protocol RemoteStore {
    func configure()
    func fetchModified(after date: Date?, limit: Int?, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

public protocol CacheStore {
    var lastPulledAt: Date? { get }
    
    func configure()
    func createOrUpdate(_ request: SeedPayloadType, lastPulledAt: Date, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
    func delete(for userID: Int)
}

public protocol DataWorkerType {
    
    /// Setup the underlying storage for use.
    func configure()
    
    /// Destroys the cache storage to start fresh.
    func resetCache(for userID: Int)
    
    /// Retrieves the latest changes from the remote source.
    ///
    /// - Parameter completion: The completion block that returns the latest changes.
    func pull(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

// MARK: - Extensions

public extension RemoteStore {
    
    func fetchModified(after date: Date, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        fetchModified(after: date, limit: nil, completion: completion)
    }
    
    func fetchModified(limit: Int, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        fetchModified(after: nil, limit: limit, completion: completion)
    }
}
