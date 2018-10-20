//
//  PostsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public struct PostsWorker: PostsWorkerType, Loggable {
    private let store: PostsStore
    private let remote: PostsRemote?
    private let preferences: PreferencesType
    private let constants: ConstantsType
    private let dataWorker: DataWorkerType
    
    public init(
        store: PostsStore,
        remote: PostsRemote?,
        preferences: PreferencesType,
        constants: ConstantsType,
        dataWorker: DataWorkerType)
    {
        self.store = store
        self.remote = remote
        self.preferences = preferences
        self.constants = constants
        self.dataWorker = dataWorker
    }
}

public extension PostsWorker {
    
    func fetch(id: Int, completion: @escaping (Result<ExpandedPostType, DataError>) -> Void) {
        store.fetch(id: id) {
            guard let remote = self.remote else { return completion($0) }
            
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = $0.error {
                return remote.fetch(id: id) {
                    guard let value = $0.value, $0.isSuccess else { return completion($0) }
                    self.store.createOrUpdate(value, completion: completion)
                }
            }
            
            // Immediately return local response
            completion($0)
            
            guard let cacheElement = $0.value, $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            remote.fetch(id: id) {
                // Validate if any updates occurred and return
                guard let element = $0.value, $0.isSuccess,
                    element.post.modifiedAt > cacheElement.post.modifiedAt else {
                        return
                }
                
                // Update local storage with updated data
                self.store.createOrUpdate(element) {
                    guard $0.isSuccess else {
                        return self.Log(error: "Could not save updated post locally from remote storage: \(String(describing: $0.error))")
                    }
                    
                    // Callback handler again if updated
                    completion($0)
                }
            }
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        store.fetch(slug: slug, completion: completion)
    }
}

public extension PostsWorker {
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch {
            // Immediately return local response
            completion($0)
            
            guard $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard $0.value?.posts.isEmpty == false, $0.isSuccess else { return }
                self.store.fetch(completion: completion)
            }
        }
    }
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetchPopular {
            // Immediately return local response
            completion($0)
            
            guard $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard $0.value?.posts.isEmpty == false, $0.isSuccess else { return }
                self.store.fetchPopular(completion: completion)
            }
        }
    }
    
    func fetchTopPicks(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch(byCategoryIDs: [constants.featuredCategoryID], completion: completion)
    }
}

public extension PostsWorker {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(ids: ids) {
            // Immediately return local response
            completion($0)
            
            guard $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard $0.value?.posts.isEmpty == false, $0.isSuccess else { return }
                self.store.fetch(ids: ids, completion: completion)
            }
        }
    }
    
    func fetch(byCategoryIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(byCategoryIDs: ids) {
            // Immediately return local response
            completion($0)
            
            guard $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard $0.value?.posts.isEmpty == false, $0.isSuccess else { return }
                self.store.fetch(byCategoryIDs: ids, completion: completion)
            }
        }
    }
    
    func fetch(byTagIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(byTagIDs: ids) {
            // Immediately return local response
            completion($0)
            
            guard $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard $0.value?.posts.isEmpty == false, $0.isSuccess else { return }
                self.store.fetch(byTagIDs: ids, completion: completion)
            }
        }
    }
    
    func fetch(byTermIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch(byTermIDs: ids) {
            // Immediately return local response
            completion($0)
            
            guard $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard $0.value?.posts.isEmpty == false, $0.isSuccess else { return }
                self.store.fetch(byTermIDs: ids, completion: completion)
            }
        }
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
