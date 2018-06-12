//
//  AuthorsMemoryStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import ZamzamKit

public struct AuthorsFileStore: AuthorsStore {
    private let store: SeedStore
    
    public init(store: SeedStore) {
        self.store = store
    }
}

public extension AuthorsFileStore {
    
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void) {
        store.fetch {
            guard let value = $0.value?.authors.first(where: { $0.id == id }) else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
}