//
//  AuthorsStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

/// Author request namespace
public enum AuthorAPI {}

public protocol AuthorStore {
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void)
    func createOrUpdate(_ request: AuthorType, completion: @escaping (Result<AuthorType, DataError>) -> Void)
}

public protocol AuthorRemote {
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void)
}

public protocol AuthorWorkerType {
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void)
}
