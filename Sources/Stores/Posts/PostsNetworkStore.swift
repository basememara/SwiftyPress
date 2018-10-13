//
//  PostsNetworkStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-10.
//

import ZamzamKit

public struct PostsNetworkStore: PostsStore, Loggable {
    private let apiSession: APISessionType
    private let seedWorker: SeedWorkerType
    
    public init(apiSession: APISessionType, seedWorker: SeedWorkerType) {
        self.apiSession = apiSession
        self.seedWorker = seedWorker
    }
}

public extension PostsNetworkStore {
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        seedWorker.fetch {
            guard let value = $0.value?.posts.sorted(by: { $0.createdAt > $1.createdAt }) else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            completion(.success(value))
        }
    }
}

public extension PostsNetworkStore {
    
    func fetch(id: Int, completion: @escaping (Result<PostType, DataError>) -> Void) {
        apiSession.request(APIRouter.readPost(id: id)) {
            // Handle errors
            guard $0.isSuccess else {
                self.Log(error: "An error occured while fetching the post: \(String(describing: $0.error)).")
                return completion(.failure(DataError(from: $0.error)))
            }
            
            // Ensure available
            guard let value = $0.value else {
                return completion(.failure(.nonExistent))
            }
            
            DispatchQueue.transform.async {
                do {
                    // Parse response data
                    let payload = try JSONDecoder.default.decode(ExpandedPost.self, from: value.data)
                    DispatchQueue.main.async { completion(.success(payload.post)) }
                } catch {
                    self.Log(error: "An error occured while parsing the post: \(error).")
                    return DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                }
            }
        }
    }
}

public extension PostsNetworkStore {
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        fetch {
            // Handle errors
            guard $0.isSuccess else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            // Find match
            guard let value = $0.value?.first(where: { $0.slug == slug }), $0.isSuccess else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
}

public extension PostsNetworkStore {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let results = value.filter {
                ids.contains($0.id)
            }
            
            completion(.success(results))
        }
    }
}

public extension PostsNetworkStore {
    
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

public extension PostsNetworkStore {
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let results = value
                .filter { $0.commentCount > 1 }
                .sorted { $0.commentCount > $1.commentCount }
            
            completion(.success(results))
        }
    }
    
    func fetchTopPicks(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch(byCategoryIDs: [64], completion: completion)
    }
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let query = request.query.lowercased()
            let isIncluded: (PostType) -> Bool
            
            switch request.scope {
            case .title: isIncluded = { $0.title.lowercased().contains(query) }
            case .content: isIncluded = { $0.content.lowercased().contains(query) }
            default: isIncluded = { $0.title.lowercased().contains(query)
                || $0.content.lowercased().contains(query) }
            }
            
            let results = value
                .filter(isIncluded)
                .sorted { $0.commentCount > $1.commentCount }
            
            completion(.success(results))
        }
    }
}
