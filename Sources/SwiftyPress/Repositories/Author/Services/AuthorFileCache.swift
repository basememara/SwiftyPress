//
//  AuthorFileCache.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

public struct AuthorFileCache: AuthorCache {
    private let seedService: DataSeed
    
    init(seedService: DataSeed) {
        self.seedService = seedService
    }
}

public extension AuthorFileCache {
    
    func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
        seedService.fetch {
            guard case let .success(item) = $0 else {
                completion(.failure($0.error ?? .unknownReason(nil)))
                return
            }
            
            // Find match
            guard let model = item.authors.first(where: { $0.id == request.id }) else {
                completion(.failure(.nonExistent))
                return
            }
            
            completion(.success(model))
        }
    }
}

public extension AuthorFileCache {
    
    func createOrUpdate(_ request: Author, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
        completion(.failure(.cacheFailure(nil)))
    }
}

public extension AuthorFileCache {
    
    func subscribe(with request: AuthorAPI.FetchRequest, in cancellable: inout Cancellable?, change block: @escaping (ChangeResult<Author, SwiftyPressError>) -> Void) {
        block(.failure(.cacheFailure(nil)))
    }
}
