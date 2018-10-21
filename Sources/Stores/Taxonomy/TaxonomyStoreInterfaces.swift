//
//  TaxonomyStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import ZamzamKit

public protocol TaxonomyStore {
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void)
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void)
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void)
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void)
}

public protocol TaxonomyWorkerType: TaxonomyStore {
    
}

public extension TaxonomyWorkerType {
    
    func fetch(url: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        guard let url = URL(string: url) else {
            return completion(.failure(.nonExistent))
        }
        
        let slug = url.lastPathComponent.lowercased()
        let relativePath = url.relativePath
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()
        
        guard relativePath.hasPrefix("category/") || relativePath .hasPrefix("tag/") else {
            return completion(.failure(.nonExistent))
        }
        
        fetch(slug: slug, completion: completion)
    }
}
