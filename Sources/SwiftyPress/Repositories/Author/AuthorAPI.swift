//
//  AuthorAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

// MARK: - Respository

public protocol AuthorRepositoryType {
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void)
}

// MARK: - Services

public protocol AuthorService {
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void)
    func createOrUpdate(_ request: AuthorType, completion: @escaping (Result<AuthorType, DataError>) -> Void)
}

public protocol AuthorRemote {
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void)
}

// MARK: - Namespace

public enum AuthorAPI {}
