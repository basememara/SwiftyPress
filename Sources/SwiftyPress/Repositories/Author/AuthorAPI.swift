//
//  AuthorAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

// MARK: - Services

public protocol AuthorService {
    func fetch(id: Int, completion: @escaping (Result<Author, SwiftyPressError>) -> Void)
    func createOrUpdate(_ request: Author, completion: @escaping (Result<Author, SwiftyPressError>) -> Void)
}

public protocol AuthorRemote {
    func fetch(id: Int, completion: @escaping (Result<Author, SwiftyPressError>) -> Void)
}

// MARK: - Namespace

public enum AuthorAPI {}
