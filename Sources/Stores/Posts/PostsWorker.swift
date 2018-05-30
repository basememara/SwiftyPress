//
//  PostsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

public protocol PostsWorkerType {
    func fetch(completion: @escaping ([PostType]) -> Void)
    func fetch(id: Int, completion: @escaping (PostType) -> Void)
    func fetch(byCategoryIDs: [Int], completion: @escaping ([PostType]) -> Void)
    func fetch(byTagIDs: [Int], completion: @escaping ([PostType]) -> Void)
    func fetchPopular(completion: @escaping ([PostType]) -> Void)
    func fetchFavorites(completion: @escaping ([PostType]) -> Void)
    func search(with request: PostsModels.SearchRequest, completion: @escaping ([PostType]) -> Void)
}

public struct PostsWorker: PostsWorkerType {
    
}

public extension PostsWorker {
    
    func fetch(completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
    
    func fetch(id: Int, completion: @escaping (PostType) -> Void) {
        fatalError("Not implemented")
    }
}

public extension PostsWorker {
    
    func fetch(byCategoryIDs: [Int], completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
    
    func fetch(byTagIDs: [Int], completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
}

public extension PostsWorker {
    
    func fetchPopular(completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
    
    func fetchFavorites(completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
}

public extension PostsWorker {
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
}
