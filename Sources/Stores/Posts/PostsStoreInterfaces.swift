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
    func fetch(byCategoryIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(byTagIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchTopPicks(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
}

public protocol PostsWorkerType: PostsStore {
    
}
