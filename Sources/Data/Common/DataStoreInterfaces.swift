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
    func fetchModified(after date: Date?, with request: DataStoreModels.ModifiedRequest, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

public protocol CacheStore {
    var lastPulledAt: Date? { get }
    
    func configure()
    func createOrUpdate(with request: DataStoreModels.CacheRequest, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
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
