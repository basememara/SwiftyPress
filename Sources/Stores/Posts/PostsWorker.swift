//
//  PostsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public struct PostsWorker: PostsWorkerType {
    private let store: PostsStore
    private let remote: PostsRemote?
    private let preferences: PreferencesType
    private let constants: ConstantsType
    
    public init(
        store: PostsStore,
        remote: PostsRemote?,
        preferences: PreferencesType,
        constants: ConstantsType)
    {
        self.store = store
        self.remote = remote
        self.preferences = preferences
        self.constants = constants
    }
}

public extension PostsWorker {
    
    func fetch(id: Int, completion: @escaping (Result<ExpandedPostType, DataError>) -> Void) {
        store.fetch(id: id, completion: completion)
    }
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        store.fetch(slug: slug, completion: completion)
    }
}

public extension PostsWorker {
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(completion: completion)
    }
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetchPopular(completion: completion)
    }
    
    func fetchTopPicks(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch(byCategoryIDs: [constants.featuredCategoryID], completion: completion)
    }
}

public extension PostsWorker {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(ids: ids, completion: completion)
    }
    
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
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.search(with: request, completion: completion)
    }
}

public extension PostsWorker {
    
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        guard let ids = preferences.get(.favorites), !ids.isEmpty else {
            return completion(.success([]))
        }
        
        fetch(ids: Set(ids), completion: completion)
    }
    
    func addFavorite(id: Int) {
        guard !hasFavorite(id: id) else { return }
        
        preferences.set(
            (preferences.get(.favorites) ?? []) + [id],
            forKey: .favorites
        )
    }
    
    func removeFavorite(id: Int) {
        preferences.set(
            preferences.get(.favorites)?.filter { $0 != id },
            forKey: .favorites
        )
    }
    
    func toggleFavorite(id: Int) {
        guard hasFavorite(id: id) else { return addFavorite(id: id) }
        removeFavorite(id: id)
    }
    
    func hasFavorite(id: Int) -> Bool {
        return preferences.get(.favorites)?.contains(id) == true
    }
}
