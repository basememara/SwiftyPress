//
//  TaxonomyMemoryStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import ZamzamKit

public struct TaxonomyFileStore: TaxonomyStore {
    private let store: SeedStore
    
    public init(store: SeedStore) {
        self.store = store
    }
}

public extension TaxonomyFileStore {
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch {
            guard let categories = $0.value?.categories, let tags = $0.value?.tags else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            completion(.success(categories + tags))
        }
    }
}

public extension TaxonomyFileStore {
    
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void) {
        fetch {
            // Handle errors
            guard $0.isSuccess else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            // Find match
            guard let value = $0.value?.first(where: { $0.id == id }) else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            completion(.success(value.filter { ids.contains($0.id) }))
        }
    }
}

public extension TaxonomyFileStore {
    
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        fetch {
            // Handle errors
            guard $0.isSuccess else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            // Find match
            guard let value = $0.value?.first(where: { $0.slug == slug }) else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
}

public extension TaxonomyFileStore {
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            completion(.success(value.filter { $0.taxonomy == taxonomy }))
        }
    }
    
    func search(with request: TaxonomyModels.SearchRequest, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            var result = value.filter {
                $0.name.range(of: request.query, options: .caseInsensitive) != nil
            }
            
            if let taxonomy = request.scope {
                result = result.filter { $0.taxonomy == taxonomy }
            }
            
            completion(.success(result))
        }
    }
}
