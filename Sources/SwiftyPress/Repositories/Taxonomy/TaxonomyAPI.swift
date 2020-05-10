//
//  TaxonomyAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

// MARK: - Cache

public protocol TaxonomyCache {
    func fetch(id: Int, completion: @escaping (Result<Term, SwiftyPressError>) -> Void)
    func fetch(slug: String, completion: @escaping (Result<Term, SwiftyPressError>) -> Void)
    
    func fetch(completion: @escaping (Result<[Term], SwiftyPressError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Term], SwiftyPressError>) -> Void)
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[Term], SwiftyPressError>) -> Void)
    func fetch(by taxonomies: [Taxonomy], completion: @escaping (Result<[Term], SwiftyPressError>) -> Void)
    
    func getID(bySlug slug: String) -> Int?
}

// MARK: - Namespace

public enum TaxonomyAPI {}
