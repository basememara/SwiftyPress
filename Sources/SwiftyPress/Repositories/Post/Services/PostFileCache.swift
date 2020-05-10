//
//  PostFileCache.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct PostFileCache: PostCache {
    private let seedService: SeedService
    
    init(seedService: SeedService) {
        self.seedService = seedService
    }
}

public extension PostFileCache {
    
    func fetch(id: Int, completion: @escaping (Result<ExtendedPost, SwiftyPressError>) -> Void) {
        seedService.fetch {
            guard case .success(let value) = $0 else {
                completion(.failure($0.error ?? .databaseFailure(nil)))
                return
            }
        
            // Find match
            guard let post = value.posts.first(where: { $0.id == id }) else {
                completion(.failure(.nonExistent))
                return
            }
            
            let model = ExtendedPost(
                post: post,
                author: value.authors.first { $0.id == post.authorID },
                media: value.media.first { $0.id == post.mediaID },
                terms: post.terms.reduce(into: [Term]()) { result, next in
                    guard let element = value.terms.first(where: { $0.id == next }) else { return }
                    result.append(element)
                }
            )
            
            completion(.success(model))
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<Post, SwiftyPressError>) -> Void) {
        fetch(with: PostAPI.FetchRequest()) {
            guard case .success(let value) = $0 else {
                completion(.failure($0.error ?? .unknownReason(nil)))
                return
            }
            
            // Find match
            guard let model = value.first(where: { $0.slug == slug }) else {
                completion(.failure(.nonExistent))
                return
            }
            
            completion(.success(model))
        }
    }
}

public extension PostFileCache {
    
    func fetch(with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        seedService.fetch {
            guard case .success(let value) = $0 else {
                completion(.failure($0.error ?? .databaseFailure(nil)))
                return
            }
            
            let data = value.posts.sorted { $0.createdAt > $1.createdAt }
            completion(.success(data))
        }
    }
    
    func fetchPopular(with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        fetch(with: request) {
            guard case .success(let value) = $0 else {
                completion($0)
                return
            }
            
            let model = value
                .filter { $0.commentCount > 1 }
                .sorted { $0.commentCount > $1.commentCount }
            
            completion(.success(model))
        }
    }
}

public extension PostFileCache {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        fetch(with: PostAPI.FetchRequest()) {
            guard case .success(let value) = $0 else {
                completion($0)
                return
            }
            
            let model = ids.reduce(into: [Post]()) { result, next in
                guard let element = value.first(where: { $0.id == next }) else { return }
                result.append(element)
            }
            
            completion(.success(model))
        }
    }
    
    func fetch(byTermIDs ids: Set<Int>, with request: PostAPI.FetchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        fetch(with: request) {
            guard case .success(let value) = $0 else {
                completion($0)
                return
            }
            
            let model = value.filter {
                $0.terms.contains(where: ids.contains)
            }
            
            completion(.success(model))
        }
    }
}

public extension PostFileCache {
    
    func search(with request: PostAPI.SearchRequest, completion: @escaping (Result<[Post], SwiftyPressError>) -> Void) {
        seedService.fetch {
            guard case .success(let value) = $0 else {
                completion(.failure($0.error ?? .databaseFailure(nil)))
                return
            }
            
            let query = request.query.lowercased()
            let isIncluded: (Post) -> Bool
            
            let titlePredicate: (Post) -> Bool = {
                $0.title.lowercased().contains(query)
            }
            
            let contentPredicate: (Post) -> Bool = {
                $0.content.lowercased().contains(query)
            }
            
            // Only perform necesary filtering if applicable
            let termIDs: [Int] = request.scope.within([.all, .terms])
                ? value.terms
                    .filter { $0.name.lowercased().contains(query) }
                    .map { $0.id }
                : []
            
            let termsPredicate: (Post) -> Bool = {
                $0.terms.contains(where: termIDs.contains)
            }
            
            switch request.scope {
            case .title:
                isIncluded = titlePredicate
            case .content:
                isIncluded = contentPredicate
            case .terms:
                isIncluded = termsPredicate
            case .all:
                isIncluded = {
                    titlePredicate($0)
                        || contentPredicate($0)
                        || termsPredicate($0)
                }
            }
            
            let results = value.posts
                .filter(isIncluded)
                .sorted { $0.commentCount > $1.commentCount }
            
            completion(.success(results))
        }
    }
}

public extension PostFileCache {
    
    func getID(bySlug slug: String) -> Int? {
        fatalError("Not implemented")
    }
}

public extension PostFileCache {
    
    func createOrUpdate(_ request: ExtendedPost, completion: @escaping (Result<ExtendedPost, SwiftyPressError>) -> Void) {
        seedService.fetch {
            guard case .success(let value) = $0 else {
                completion(.failure($0.error ?? .databaseFailure(nil)))
                return
            }
            
            let model = SeedPayload(
                posts: value.posts + {
                    guard !value.posts.contains(where: { $0.id == request.post.id }) else {
                        return []
                    }
                    
                    return [request.post]
                }(),
                authors: value.authors + {
                    guard let author = request.author,
                        !value.authors.contains(where: { $0.id == author.id }) else {
                            return []
                    }
                    
                    return [author]
                }(),
                media: value.media + {
                    guard let media = request.media,
                        !value.media.contains(where: { $0.id == media.id }) else {
                            return []
                    }
                    
                    return [media]
                }(),
                terms: value.terms.compactMap { term in
                    guard !value.terms.contains(where: { $0.id == term.id }) else { return nil }
                    return term
                }
            )
            
            guard let seedFileStore = self.seedService as? SeedFileService else {
                completion(.failure(.databaseFailure(nil)))
                return
            }
            
            seedFileStore.set(data: model)
            completion(.success(request))
        }
    }
}
