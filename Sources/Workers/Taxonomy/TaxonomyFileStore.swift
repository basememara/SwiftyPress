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
            guard case .success = $0 else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            // Find match
            guard case .success(let value) = $0,
                let model = value.first(where: { $0.id == id }) else {
                    return completion(.failure(.nonExistent))
            }
            
            completion(.success(model))
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        fetch {
            // Handle errors
            guard case .success = $0 else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            // Find match
            guard case .success(let value) = $0,
                let model = value.first(where: { $0.slug == slug }) else {
                    return completion(.failure(.nonExistent))
            }
            
            completion(.success(model))
        }
    }
}

public extension TaxonomyFileStore {
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        seedStore.fetch {
            guard case .success(let value) = $0 else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            completion(.success(value.categories + value.tags))
        }
    }
}

public extension TaxonomyFileStore {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard case .success(let value) = $0 else { return completion($0) }
            
            let model = ids.reduce(into: [TermType]()) { result, next in
                guard let element = value.first(where: { $0.id == next }) else { return }
                result.append(element)
            }
            
            completion(.success(model))
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard case .success(let value) = $0 else { return completion($0) }
            completion(.success(value.filter { $0.taxonomy == taxonomy }))
        }
    }
}

public extension TaxonomyFileStore {
    
    func getID(bySlug slug: String) -> Int? {
        fatalError("Not implemented")
    }
}