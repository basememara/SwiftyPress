//
//  TaxonomyAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL

// MARK: - Respository

public protocol TaxonomyRepositoryType: TaxonomyService {
    func getID(byURL url: String) -> Int?
}

public extension TaxonomyRepositoryType {
    
    func fetch(url: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        guard let slug = slug(from: url) else {
            completion(.failure(.nonExistent))
            return
        }
        
        fetch(slug: slug, completion: completion)
    }
    
    func getID(byURL url: String) -> Int? {
        guard let slug = slug(from: url) else { return nil }
        return getID(bySlug: slug)
    }
}

private extension TaxonomyRepositoryType {
    
    func slug(from url: String) -> String? {
        guard let url = URL(string: url) else { return nil }
        
        let slug = url.lastPathComponent.lowercased()
        let relativePath = url.relativePath
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()
        
        return relativePath.hasPrefix("category/") || relativePath .hasPrefix("tag/")
            ? slug : nil
    }
}

// MARK: - Service

public protocol TaxonomyService {
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void)
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void)
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void)
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void)
    func fetch(by taxonomies: [Taxonomy], completion: @escaping (Result<[TermType], DataError>) -> Void)
    
    func getID(bySlug slug: String) -> Int?
}

// MARK: - Namespace

public enum TaxonomyAPI {}
