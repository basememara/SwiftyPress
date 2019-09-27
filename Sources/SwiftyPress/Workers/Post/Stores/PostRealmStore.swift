//
//  PostRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-13.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import RealmSwift
import ZamzamCore

public struct PostRealmStore: PostStore, Loggable {
    
}

public extension PostRealmStore {
    
    func fetch(id: Int, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            guard let object = realm.object(ofType: PostRealmObject.self, forPrimaryKey: id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = self.extend(post: object, with: realm)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<PostType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            guard let object = realm.objects(PostRealmObject.self).filter("slug == %@", slug).first else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = Post(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

public extension PostRealmStore {
    
    func fetch(with request: PostsAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                .sorted(byKeyPath: "createdAt", ascending: false)
                .prefixMap(request.maxLength) { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetchPopular(with request: PostsAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                .filter("commentCount > 1")
                .sorted(byKeyPath: "commentCount", ascending: false)
                .prefixMap(request.maxLength) { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension PostRealmStore {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [PostType] = realm.objects(PostRealmObject.self, forPrimaryKeys: ids)
                .sorted(byKeyPath: "createdAt", ascending: false)
                .map { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetch(byTermIDs ids: Set<Int>, with request: PostsAPI.FetchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                .filter("ANY termsRaw.id IN %@", ids, ids)
                .sorted(byKeyPath: "createdAt", ascending: false)
                .prefixMap(request.maxLength) { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension PostRealmStore {
    
    func search(with request: PostsAPI.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        guard !request.query.isEmpty else { return completion(.success([])) }
        
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            // Construct predicate builder
            var predicates = [NSPredicate]()
            
            // By title
            if request.scope.within([.title, .all]) {
                predicates.append(NSPredicate(format: "title CONTAINS[c] %@", request.query))
            }
            
            // By content
            if request.scope.within([.content, .all]) {
                predicates.append(NSPredicate(format: "content CONTAINS[c] %@", request.query))
            }
            
            // By keywords
            if request.scope.within([.terms, .all]) {
                let termIDs = Array(
                    realm.objects(TermRealmObject.self)
                        .filter("name CONTAINS[c] %@", request.query)
                        .map { $0.id }
                )
                
                if !termIDs.isEmpty {
                    predicates.append(NSPredicate(format: "ANY termsRaw.id IN %@", termIDs, termIDs))
                }
            }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                .filter(NSCompoundPredicate(orPredicateWithSubpredicates: predicates))
                .sorted(byKeyPath: "createdAt", ascending: false)
                .prefixMap(request.maxLength) { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension PostRealmStore {
    
    func getID(bySlug slug: String) -> Int? {
        let realm: Realm
        
        do {
            realm = try Realm()
        } catch {
            return nil
        }
        
        return realm.objects(PostRealmObject.self)
            .filter("slug == %@", slug)
            .first?
            .id
    }
}

public extension PostRealmStore {
    
    func createOrUpdate(_ request: ExtendedPostType, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            do {
                try realm.write {
                    realm.add(PostRealmObject(from: request.post), update: .modified)
                    realm.add(MediaRealmObject(from: request.media), update: true)
                    realm.add(AuthorRealmObject(from: request.author), update: true)
                    realm.add(
                        request.terms.map { TermRealmObject(from: $0) },
                        update: .modified
                    )
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            // Get refreshed object to return
            guard let object = realm.object(ofType: PostRealmObject.self, forPrimaryKey: request.post.id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = self.extend(post: object, with: realm)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

// MARK: - Helpers

private extension PostRealmStore {
    
    /// Extend post with linked objects
    func extend(post: PostType, with realm: Realm) -> ExtendedPostType {
        return ExtendedPost(
            post: Post(from: post),
            author: Author(
                from: realm.object(
                    ofType: AuthorRealmObject.self,
                    forPrimaryKey: post.authorID
                )
            ),
            media: {
                guard let id = post.mediaID else { return nil }
                return Media(
                    from: realm.object(
                        ofType: MediaRealmObject.self,
                        forPrimaryKey: id
                    )
                )
            }(),
            terms: realm.objects(TermRealmObject.self)
                .filter("id IN %@", post.terms)
                .map { Term(from: $0) }
        )
    }
}
