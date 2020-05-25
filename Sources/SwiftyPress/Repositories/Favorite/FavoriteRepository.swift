//
//  FavoriteRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2020-05-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import ZamzamCore

public struct FavoriteRepository {
    private let postRepository: PostRepository
    private let preferences: Preferences
    
    public init(postRepository: PostRepository, preferences: Preferences) {
        self.postRepository = postRepository
        self.preferences = preferences
    }
}

public extension FavoriteRepository {
    
    func fetch(completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        guard !preferences.favorites.isEmpty else {
            completion(.success([]))
            return
        }
        
        postRepository.fetch(ids: Set(preferences.favorites), completion: completion)
    }
    
    func fetchIDs(completion: @escaping (Result<[Int], SwiftyPressError>) -> Void) {
        completion(.success(preferences.favorites))
    }
    
    func add(id: Int) {
        guard !contains(id: id) else { return }
        preferences.set(favorites: preferences.favorites + [id])
    }
    
    func remove(id: Int) {
        let updated = preferences.favorites.filter { $0 != id }
        preferences.set(favorites: updated)
    }
    
    func toggle(id: Int) {
        contains(id: id) ? remove(id: id) : add(id: id)
    }
    
    func contains(id: Int) -> Bool {
        preferences.favorites.contains(id)
    }
}
