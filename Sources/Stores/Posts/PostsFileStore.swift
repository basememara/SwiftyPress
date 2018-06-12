//
//  PostsFileStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public struct PostsFileStore: PostsStore {
    private let store: SeedStore
    
    public init(store: SeedStore) {
        self.store = store
    }
}

public extension PostsFileStore {
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        store.fetch {
            guard let value = $0.value?.posts else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            completion(.success(value))
        }
    }
    
    func fetch(id: Int, completion: @escaping (Result<PostType, DataError>) -> Void) {
        fetch {
            guard let value = $0.value?.first(where: { $0.id == id }), $0.isSuccess else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
}

public extension PostsFileStore {
    
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
}

public extension PostsFileStore {
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
    
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
}
