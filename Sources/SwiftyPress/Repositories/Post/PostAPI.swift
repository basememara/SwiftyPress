//
//  PostAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public protocol PostService {
    func fetch(id: Int, with request: PostAPI.ItemRequest, completion: @escaping (Result<ExtendedPost, SwiftyPressError>) -> Void)
}

// MARK: - Cache

public protocol PostCache {
    func fetch(id: Int, completion: @escaping (Result<ExtendedPost, SwiftyPressError>) -> Void)
    func fetch(slug: String, completion: @escaping (Result<Post, SwiftyPressError>) -> Void)
    
    func fetch(with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void)
    func fetchPopular(with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void)
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void)
    func fetch(byTermIDs ids: Set<Int>, with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void)
    
    func search(with request: PostAPI.SearchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void)
    func getID(bySlug slug: String) -> Int?
    
    func createOrUpdate(_ request: ExtendedPost, completion: @escaping (Result<ExtendedPost, SwiftyPressError>) -> Void)
}

// MARK: Namespace

public enum PostAPI {
    
    public struct FetchRequest {
        let maxLength: Int?
        
        public init(maxLength: Int? = nil) {
            self.maxLength = maxLength
        }
    }
    
    public struct ItemRequest {
        let taxonomies: [String]
        let postMetaKeys: [String]
    }
    
    public enum SearchScope {
        case all
        case title
        case content
        case terms
    }
    
    public struct SearchRequest {
        let query: String
        let scope: SearchScope
        let maxLength: Int?
        
        public init(query: String, scope: SearchScope, maxLength: Int? = nil) {
            self.query = query
            self.scope = scope
            self.maxLength = maxLength
        }
    }
}
