//
//  PostsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public struct PostsWorker: PostsWorkerType {
    private let store: PostsStore
    
    public init(store: PostsStore) {
        self.store = store
    }
}

public extension PostsWorker {
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(completion: completion)
    }
    
    func fetch(id: Int, completion: @escaping (Result<PostType, DataError>) -> Void) {
        store.fetch(id: id, completion: completion)
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(ids: ids, completion: completion)
    }
}

public extension PostsWorker {
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        store.fetch(slug: slug, completion: completion)
    }
}

public extension PostsWorker {
    
    func fetch(byCategoryIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(byCategoryIDs: ids, completion: completion)
    }
    
    func fetch(byTagIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(byTagIDs: ids, completion: completion)
    }
    
    func fetch(byTermIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(byTermIDs: ids, completion: completion)
    }
}

public extension PostsWorker {
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetchPopular(completion: completion)
    }
    
    func fetchTopPicks(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetchTopPicks(completion: completion)
    }
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.search(with: request, completion: completion)
    }
}

public extension PostsWorker {
    
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetchFavorites(completion: completion)
    }
    
    func addFavorite(id: Int) {
        store.addFavorite(id: id)
    }
    
    func removeFavorite(id: Int) {
        store.removeFavorite(id: id)
    }
    
    func toggleFavorite(id: Int) {
        store.toggleFavorite(id: id)
    }
    
    func hasFavorite(id: Int) -> Bool {
        return store.hasFavorite(id: id)
    }
}
