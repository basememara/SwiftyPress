//
//  PostsStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

import ZamzamKit

public protocol PostsStore {
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(id: Int, completion: @escaping (Result<PostType, DataError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void)
    func fetch(byCategoryIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(byTagIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(byTermIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchTopPicks(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
}

public protocol PostsWorkerType: PostsStore {
    
}

public extension PostsWorkerType {
    
    func fetch(url: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        guard let slug = URL(string: url)?.relativePath.lowercased()
            .replace(regex: "\\d{4}/\\d{2}/\\d{2}/", with: "") // Handle legacy permalinks
            .trimmingCharacters(in: CharacterSet(charactersIn: "/")) else {
                return completion(.failure(.nonExistent))
        }
        
        fetch(slug: slug, completion: completion)
    }
}
