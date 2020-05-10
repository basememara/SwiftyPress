//
//  DataAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

// MARK: - Services

public protocol DataService {
    func fetchModified(after date: Date?, with request: DataAPI.ModifiedRequest, completion: @escaping (Result<SeedPayload, SwiftyPressError>) -> Void)
}

// MARK: - Cache

public protocol DataCache {
    var lastFetchedAt: Date? { get }
    
    func configure()
    func createOrUpdate(with request: DataAPI.CacheRequest, completion: @escaping (Result<SeedPayload, SwiftyPressError>) -> Void)
    func delete(for userID: Int)
}

// MARK: - Seed

public protocol DataSeed {
    func configure()
    func fetch(completion: @escaping (Result<SeedPayload, SwiftyPressError>) -> Void)
}

// MARK: - Namespace

public enum DataAPI {
    
    public struct ModifiedRequest {
        let taxonomies: [String]
        let postMetaKeys: [String]
        let limit: Int?
    }
    
    public struct CacheRequest {
        let payload: SeedPayload
        let lastFetchedAt: Date
    }
}
