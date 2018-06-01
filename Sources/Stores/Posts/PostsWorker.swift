//
//  PostsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public protocol PostsWorkerType {
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(id: Int, completion: @escaping (Result<PostType, DataError>) -> Void)
    func fetch(byCategoryIDs: [Int], completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetch(byTagIDs: [Int], completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void)
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void)
}
