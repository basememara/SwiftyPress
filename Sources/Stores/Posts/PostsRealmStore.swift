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
    
    func fetch(id: Int, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            guard let object = realm.object(ofType: PostRealmObject.self, forPrimaryKey: id) else {
                return DispatchQueue.main.async { completion(.failure(.nonExistent)) }
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
    
    func fetch(byTermIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                .filter("ANY categoriesRaw.id IN %@ OR ANY tagsRaw.id IN %@", ids, ids)
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
        guard !request.query.isEmpty else { return completion(.success([])) }
        
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
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
                    predicates.append(NSPredicate(format: "ANY categoriesRaw.id IN %@ OR ANY tagsRaw.id IN %@", termIDs, termIDs))
                }
            }
            
            let items: [PostType] = realm.objects(PostRealmObject.self)
                .filter(NSCompoundPredicate(orPredicateWithSubpredicates: predicates))
                .sorted(byKeyPath: "createdAt", ascending: false)
                .map { Post(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension PostsRealmStore {
    
    func getID(bySlug slug: String) -> Int? {
        let realm: Realm
        
        do { realm = try Realm() }
        catch { return nil }
        
        return realm.objects(PostRealmObject.self)
            .filter("slug == %@", slug)
            .first?
            .id
    }
}

public extension PostsRealmStore {
    
    func createOrUpdate(_ request: ExtendedPostType, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            do {
                try realm.write {
                    realm.add(PostRealmObject(from: request.post), update: true)
                    realm.add(MediaRealmObject(from: request.media), update: true)
                    realm.add(AuthorRealmObject(from: request.author), update: true)
                    realm.add(
                        (request.categories + request.tags).map { TermRealmObject(from: $0) },
                        update: true
                    )
                }
            } catch {
                return DispatchQueue.main.async {
                    completion(.failure(.databaseFailure(error)))
                }
            }
            
            // Get refreshed object to return
            guard let object = realm.object(ofType: PostRealmObject.self, forPrimaryKey: request.post.id) else {
                return DispatchQueue.main.async { completion(.failure(.nonExistent)) }
            }
            
            let item = self.extend(post: object, with: realm)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

// MARK: - Helpers

private extension PostsRealmStore {
    
    /// Extend post with linked objects
    func extend(post: PostType, with realm: Realm) -> ExtendedPostType {
        return ExtendedPostType(
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
            categories: realm.objects(TermRealmObject.self)
                .filter("id IN %@", post.categories)
                .map { Term(from: $0) },
            tags: realm.objects(TermRealmObject.self)
                .filter("id IN %@", post.tags)
                .map { Term(from: $0) }
        )
    }
}
