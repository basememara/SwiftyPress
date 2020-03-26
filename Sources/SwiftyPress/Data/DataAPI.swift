//
//  DataAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

// MARK: - Respository

public protocol DataRepositoryType {
    
    /// Setup the underlying storage for use.
    func configure()
    
    /// Destroys the cache storage to start fresh.
    func resetCache(for userID: Int)
    
    /// Retrieves the latest changes from the remote source.
    ///
    /// - Parameter completion: The completion block that returns the latest changes.
    func pull(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

// MARK: - Services

public protocol SeedService {
    func configure()
    func fetch(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

public protocol RemoteService {
    func configure()
    func fetchModified(after date: Date?, with request: DataAPI.ModifiedRequest, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
}

public protocol CacheService {
    var lastPulledAt: Date? { get }
    
    func configure()
    func createOrUpdate(with request: DataAPI.CacheRequest, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void)
    func delete(for userID: Int)
}

// MARK: - Namespace

public enum DataAPI {
    
    public struct ModifiedRequest {
        let taxonomies: [String]
        let postMetaKeys: [String]
        let limit: Int?
    }
    
    public struct CacheRequest {
        let payload: SeedPayloadType
        let lastPulledAt: Date
    }
}
