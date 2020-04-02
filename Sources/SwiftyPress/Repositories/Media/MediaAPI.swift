//
//  MediaAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

// MARK: - Repository

public protocol MediaRepositoryType {
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[MediaType], DataError>) -> Void)
}

// MARK: - Services

public protocol MediaService {
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[MediaType], DataError>) -> Void)
    func createOrUpdate(_ request: MediaType, completion: @escaping (Result<MediaType, DataError>) -> Void)
}

public protocol MediaRemote {
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void)
}

// MARK: - Namespace

public enum MediaAPI {}
