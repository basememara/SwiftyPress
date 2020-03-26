//
//  PostAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL

// MARK: - Repository

public protocol PostRepositoryType {
    func fetch(id: Int, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void)
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void)
    
    func fetch(with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchPopular(with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchTopPicks(with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(byTermIDs ids: Set<Int>, with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    
    func search(with request: PostAPI.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func getID(bySlug slug: String) -> Int?
    func getID(byURL url: String) -> Int?
    
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func addFavorite(id: Int)
    func removeFavorite(id: Int)
    func toggleFavorite(id: Int)
    func hasFavorite(id: Int) -> Bool
}

public extension PostRepositoryType {
    
    func fetch(url: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        guard let slug = slug(from: url) else { return completion(.failure(.nonExistent)) }
        fetch(slug: slug, completion: completion)
    }
    
    func getID(byURL url: String) -> Int? {
        guard let slug = slug(from: url) else { return nil }
        return getID(bySlug: slug)
    }
}

private extension PostRepositoryType {
    
    func slug(from url: String) -> String? {
        URL(string: url)?.relativePath.lowercased()
            .replacing(regex: "\\d{4}/\\d{2}/\\d{2}/", with: "") // Handle legacy permalinks
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}

// MARK: - Services

public protocol PostService {
    func fetch(id: Int, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void)
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void)
    
    func fetch(with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchPopular(with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(byTermIDs ids: Set<Int>, with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    
    func search(with request: PostAPI.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func getID(bySlug slug: String) -> Int?
    
    func createOrUpdate(_ request: ExtendedPostType, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void)
}

public protocol PostRemote {
    func fetch(id: Int, with request: PostAPI.ItemRequest, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void)
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
