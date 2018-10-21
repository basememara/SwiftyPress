//
//  TaxonomyMemoryStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import ZamzamKit

public struct TaxonomyFileStore: TaxonomyStore {
    private let seedStore: SeedStore
    
    init(seedStore: SeedStore) {
        self.seedStore = seedStore
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
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        seedStore.fetch {
            guard let data = $0.value, $0.isSuccess else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            completion(.success(data.categories + data.tags))
        }
    }
}

public extension TaxonomyFileStore {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard let terms = $0.value, $0.isSuccess else { return completion($0) }
            
            let value = ids.reduce(into: [TermType]()) { result, next in
                guard let element = terms.first(where: { $0.id == next }) else { return }
                result.append(element)
            }
            
            completion(.success(value))
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            completion(.success(value.filter { $0.taxonomy == taxonomy }))
        }
    }
}
