//
//  PostsMemoryStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

@testable import SwiftyPress
import ZamzamKit

public struct PostsMemoryStore: PostsStore {
    private let preferences: PreferencesType
    
    public init(preferences: PreferencesType) {
        self.preferences = preferences
    }
}

public extension PostsMemoryStore {
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        completion(.success([
            Post(
                id: 1,
                slug: "test-post-1",
                type: "post",
                title: "Test post 1",
                content: "This is a test description 1.",
                excerpt: "This is a test excerpt 1.",
                link: "http://example.com/test-post-1",
                commentCount: 101,
                authorID: 1,
                mediaID: 1,
                categories: [1, 2, 3],
                tags: [10, 20, 30],
                createdAt: Date(),
                modifiedAt: Date()
            ),
            Post(
                id: 2,
                slug: "test-post-2",
                type: "post",
                title: "Test post 2",
                content: "This is a test description 2.",
                excerpt: "This is a test excerpt 2.",
                link: "http://example.com/test-post-2",
                commentCount: 102,
                authorID: 1,
                mediaID: 2,
                categories: [3, 4, 5, 6],
                tags: [10, 11, 21, 31],
                createdAt: Date(),
                modifiedAt: Date()
            ),
            Post(
                id: 3,
                slug: "test-post-3",
                type: "post",
                title: "Test post 3",
                content: "This is a test description 3.",
                excerpt: "This is a test excerpt 3.",
                link: "http://example.com/test-post-3",
                commentCount: 103,
                authorID: 1,
                mediaID: 3,
                categories: [6, 7, 8, 9],
                tags: [11, 12, 22, 32],
                createdAt: Date(),
                modifiedAt: Date()
            )
        ]))
    }
    
    func fetch(id: Int, completion: @escaping (Result<PostType, DataError>) -> Void) {
        fetch {
            guard let value = $0.value?.first(where: { $0.id == id }), $0.isSuccess else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let results = value.filter {
                ids.contains($0.id)
            }
            
            completion(.success(results))
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        fetch {
            guard let value = $0.value?.first(where: { $0.slug == slug }), $0.isSuccess else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
}

public extension PostsMemoryStore {
    
    func fetch(byCategoryIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let results = value.filter {
                $0.categories.contains(where: ids.contains)
            }
            
            completion(.success(results))
        }
    }
    
    func fetch(byTagIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let results = value.filter {
                $0.tags.contains(where: ids.contains)
            }
            
            completion(.success(results))
        }
    }
    
    func fetch(byTermIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let results = value.filter {
                ($0.categories + $0.tags).contains(where: ids.contains)
            }
            
            completion(.success(results))
        }
    }
}

public extension PostsMemoryStore {
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
    
    func fetchTopPicks(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
}

public extension PostsMemoryStore {
    
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

