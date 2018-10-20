//
//  PostsRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-13.
//

import ZamzamKit
import RealmSwift

public struct PostsRealmStore: PostsStore, Loggable {
    
}

public extension PostsRealmStore {
    
    func fetch(id: Int, completion: @escaping (Result<ExpandedPostType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            guard let object = realm.object(ofType: PostRealmObject.self, forPrimaryKey: id) else {
                return DispatchQueue.main.async { completion(.failure(.nonExistent)) }
            }
            
            let item = ExpandedPostType(from: Post(from: object), with: realm)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            guard let object = realm.objects(PostRealmObject.self).filter("slug == %@", slug).first else {
                return DispatchQueue.main.async { completion(.failure(.nonExistent)) }
            }
            
            let item = Post(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

public extension PostsRealmStore {
    
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                .sorted(byKeyPath: "createdAt", ascending: false)
                .map { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                .filter("commentCount > 1")
                .sorted(byKeyPath: "commentCount", ascending: false)
                .map { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension PostsRealmStore {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [PostType] = realm.objects(PostRealmObject.self, forPrimaryKeys: ids)
                .sorted(byKeyPath: "createdAt", ascending: false)
                .map { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetch(byCategoryIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                //.filter("ANY categoriesRaw IN %@", ids)
                .sorted(byKeyPath: "createdAt", ascending: false)
                .map { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetch(byTagIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                //.filter("ANY tagsRaw IN %@", ids)
                .sorted(byKeyPath: "createdAt", ascending: false)
                .map { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetch(byTermIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                //.filter("ANY categoriesRaw IN %@ OR ANY tagsRaw IN %@", ids, ids)
                .sorted(byKeyPath: "createdAt", ascending: false)
                .map { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension PostsRealmStore {
    
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        
    }
}

public extension PostsRealmStore {
    
    
    func createOrUpdate(_ request: ExpandedPostType, completion: @escaping (Result<ExpandedPostType, DataError>) -> Void) {
        
    }
}
