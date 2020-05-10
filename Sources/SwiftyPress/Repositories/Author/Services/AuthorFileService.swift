//
//  AuthorFileService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct AuthorFileService: AuthorService {
    private let seedService: SeedService
    
    init(seedService: SeedService) {
        self.seedService = seedService
    }
}

public extension AuthorFileService {
    
    func fetch(id: Int, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
        seedService.fetch {
            guard case .success(let value) = $0 else {
                completion(.failure($0.error ?? .unknownReason(nil)))
                return
            }
            
            // Find match
            guard let model = value.authors.first(where: { $0.id == id }) else {
                completion(.failure(.nonExistent))
                return
            }
            
            completion(.success(model))
        }
    }
}

public extension AuthorFileService {
    
    func createOrUpdate(_ request: Author, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
        // Nothing to do
    }
}
