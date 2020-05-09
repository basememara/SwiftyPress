//
//  PostRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

public struct PostRepository: PostRepositoryType {
    private let service: PostService
    private let remote: PostRemote?
    private let dataRepository: DataRepositoryType
    private let preferences: PreferencesType
    private let constants: ConstantsType
    private let log: LogRepository
    
    public init(
        service: PostService,
        remote: PostRemote?,
        dataRepository: DataRepositoryType,
        preferences: PreferencesType,
        constants: ConstantsType,
        log: LogRepository
    ) {
        self.service = service
        self.remote = remote
        self.dataRepository = dataRepository
        self.preferences = preferences
        self.constants = constants
        self.log = log
    }
}

public extension PostRepository {
    
    func fetch(id: Int, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void) {
        service.fetch(id: id) {
            guard let remote = self.remote else {
                completion($0)
                return
            }
            
            let request = PostAPI.ItemRequest(
                taxonomies: self.constants.taxonomies,
                postMetaKeys: self.constants.postMetaKeys
            )
            
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = $0.error {
                remote.fetch(id: id, with: request) {
                    guard case .success(let value) = $0 else {
                        completion($0)
                        return
                    }
                    
                    self.service.createOrUpdate(value, completion: completion)
                }
                
                return 
            }
            
            // Immediately return local response
            completion($0)
            
            guard case .success(let cacheElement) = $0 else { return }
            
            // Sync remote updates to cache if applicable
            remote.fetch(id: id, with: request) {
                // Validate if any updates occurred and return
                guard case .success(let element) = $0,
                    element.post.modifiedAt > cacheElement.post.modifiedAt else {
                        return
                }
                
                // Update local storage with updated data
                self.service.createOrUpdate(element) {
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
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        service.fetch(slug: slug) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataRepository.pull {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.posts.contains(where: { $0.slug == slug }) else {
                        completion(result)
                        return
                    }
                    
                    self.service.fetch(slug: slug, completion: completion)
                }
                
                return
            }
            
            completion(result)
        }
    }
}

public extension PostRepository {
    
    func fetch(with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        service.fetch(with: request) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0, !value.posts.isEmpty else { return }
                self.service.fetch(with: request, completion: completion)
            }
        }
    }
    
    func fetchPopular(with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        service.fetchPopular(with: request) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0, !value.posts.isEmpty else { return }
                self.service.fetchPopular(with: request, completion: completion)
            }
        }
    }
    
    func fetchTopPicks(with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch(byTermIDs: [constants.featuredCategoryID], with: request, completion: completion)
    }
}

public extension PostRepository {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        service.fetch(ids: ids) {
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
                
                self.service.fetch(ids: ids, completion: completion)
            }
        }
    }
    
    func fetch(byTermIDs ids: Set<Int>, with request: PostAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        service.fetch(byTermIDs: ids, with: request) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                guard case .success(let value) = $0 else { return }
                
                // Validate if any updates that needs to be stored
                let modifiedIDs = Set(value.posts.flatMap { $0.terms })
                guard ids.contains(where: modifiedIDs.contains) else { return }
                self.service.fetch(byTermIDs: ids, with: request, completion: completion)
            }
        }
    }
}

public extension PostRepository {
    
    func search(with request: PostAPI.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        service.search(with: request, completion: completion)
    }
}

public extension PostRepository {
    
    func getID(bySlug slug: String) -> Int? {
        service.getID(bySlug: slug)
    }
}

public extension PostRepository {
    
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void) {
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
