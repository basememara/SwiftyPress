//
//  TaxonomyStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public protocol TaxonomyStore {
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void)
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void)
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void)
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void)
    
    func getID(bySlug slug: String) -> Int?
}

public protocol TaxonomyWorkerType: TaxonomyStore {
    func getID(byURL url: String) -> Int?
}

public extension TaxonomyWorkerType {
    
    func fetch(url: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        guard let slug = slug(from: url) else { return completion(.failure(.nonExistent)) }
        fetch(slug: slug, completion: completion)
    }
    
    func getID(byURL url: String) -> Int? {
        guard let slug = slug(from: url) else { return nil }
        return getID(bySlug: slug)
    }
}

private extension TaxonomyWorkerType {
    
    func slug(from url: String) -> String? {
        guard let url = URL(string: url) else { return nil }
        
        let slug = url.lastPathComponent.lowercased()
        let relativePath = url.relativePath
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()
        
        guard relativePath.hasPrefix("category/") || relativePath .hasPrefix("tag/") else {
            return nil
        }
        
        return slug
    }
}
