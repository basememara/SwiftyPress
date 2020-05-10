//
//  PostRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL
import ZamzamCore

public struct PostRepository {
    private let service: PostService
    private let cache: PostCache
    private let dataRepository: DataRepository
    private let preferences: Preferences
    private let constants: Constants
    private let log: LogRepository
    
    public init(
        service: PostService,
        cache: PostCache,
        dataRepository: DataRepository,
        preferences: Preferences,
        constants: Constants,
        log: LogRepository
    ) {
        self.service = service
        self.cache = cache
        self.dataRepository = dataRepository
        self.preferences = preferences
        self.constants = constants
        self.log = log
    }
}

public extension PostRepository {
    
    func fetch(id: Int, completion: @escaping (Result<ExtendedPost, SwiftyPressError>) -> Void) {
        cache.fetch(id: id) {
            let request = PostAPI.ItemRequest(
                taxonomies: self.constants.taxonomies,
                postMetaKeys: self.constants.postMetaKeys
            )
            
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = $0.error {
                self.service.fetch(id: id, with: request) {
                    guard case .success(let value) = $0 else {
                        completion($0)
                        return
                    }
                    
                    self.cache.createOrUpdate(value, completion: completion)
                }
                
                return 
            }
            
            // Immediately return local response
            completion($0)
            
            guard case .success(let cacheElement) = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.service.fetch(id: id, with: request) {
                // Validate if any updates occurred and return
                guard case .success(let element) = $0,
                    element.post.modifiedAt > cacheElement.post.modifiedAt else {
                        return
                }
                
                // Update local storage with updated data
                self.cache.createOrUpdate(element) {
                    guard case .success = $0 else {
                        self.log.error("Could not save updated post locally from remote storage: \(String(describing: $0.error))")
                        return
                    }
                    
                    // Callback handler again if updated
                    completion($0)
                }
            }
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<Post, SwiftyPressError>) -> Void) {
        cache.fetch(slug: slug) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataRepository.pull {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.posts.contains(where: { $0.slug == slug }) else {
                        completion(result)
                        return
                    }
                    
                    self.cache.fetch(slug: slug, completion: completion)
                }
                
                return
            }
            
            completion(result)
        }
    }
    
    func fetch(url: String, completion: @escaping (Result<Post, SwiftyPressError>) -> Void) {
        guard let slug = slug(from: url) else { return completion(.failure(.nonExistent)) }
        fetch(slug: slug, completion: completion)
    }
}

public extension PostRepository {
    
    func fetch(with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        cache.fetch(with: request) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0, !value.posts.isEmpty else { return }
                self.cache.fetch(with: request, completion: completion)
            }
        }
    }
    
    func fetchPopular(with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        cache.fetchPopular(with: request) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0, !value.posts.isEmpty else { return }
                self.cache.fetchPopular(with: request, completion: completion)
            }
        }
    }
    
    func fetchTopPicks(with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        fetch(byTermIDs: [constants.featuredCategoryID], with: request, completion: completion)
    }
}

public extension PostRepository {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        cache.fetch(ids: ids) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    value.posts.contains(where: { ids.contains($0.id) }) else {
                        return
                }
                
                self.cache.fetch(ids: ids, completion: completion)
            }
        }
    }
    
    func fetch(byTermIDs ids: Set<Int>, with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        cache.fetch(byTermIDs: ids, with: request) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                guard case .success(let value) = $0 else { return }
                
                // Validate if any updates that needs to be stored
                let modifiedIDs = Set(value.posts.flatMap { $0.terms })
                guard ids.contains(where: modifiedIDs.contains) else { return }
                self.cache.fetch(byTermIDs: ids, with: request, completion: completion)
            }
        }
    }
}

public extension PostRepository {
    
    func search(with request: PostAPI.SearchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        cache.search(with: request, completion: completion)
    }
}

public extension PostRepository {
    
    func getID(bySlug slug: String) -> Int? {
        cache.getID(bySlug: slug)
    }
    
    func getID(byURL url: String) -> Int? {
        guard let slug = slug(from: url) else { return nil }
        return getID(bySlug: slug)
    }
}

public extension PostRepository {
    
    func fetchFavorites(completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        guard let ids = preferences.get(.favorites), !ids.isEmpty else {
            completion(.success([]))
            return
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
        hasFavorite(id: id) ? removeFavorite(id: id) : addFavorite(id: id)
    }
    
    func hasFavorite(id: Int) -> Bool {
        preferences.get(.favorites)?.contains(id) == true
    }
}

// MARK: - Helpers

private extension PostRepository {
    
    func slug(from url: String) -> String? {
        URL(string: url)?.relativePath.lowercased()
            .replacing(regex: "\\d{4}/\\d{2}/\\d{2}/", with: "") // Handle legacy permalinks
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}
