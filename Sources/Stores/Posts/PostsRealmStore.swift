//
//  PostsRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-13.
//

import ZamzamKit

public struct PostsRealmStore: PostsStore, Loggable {
    
}

public extension PostsRealmStore {
    
    func fetch(id: Int, completion: @escaping (Result<ExpandedPostType, DataError>) -> Void) {
        
    }
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        
    }
}

public extension PostsRealmStore {
    
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        
    }
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        
    }
}

public extension PostsRealmStore {
    
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        
    }
    
    func fetch(byCategoryIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        
    }
    
    func fetch(byTagIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
    
    }
    
    func fetch(byTermIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        
    }
}

public extension PostsRealmStore {
    
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        
    }
}

public extension PostsRealmStore {
    
    
    func createOrUpdate(_ request: ExpandedPostType, completion: @escaping (Result<ExpandedPostType, DataError>) -> Void) {
        
    }
}
