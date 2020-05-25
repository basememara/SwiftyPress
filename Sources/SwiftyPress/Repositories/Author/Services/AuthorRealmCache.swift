//
//  AuthorRealmCache.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import RealmSwift
import ZamzamCore

public struct AuthorRealmCache: AuthorCache {
    private let log: LogRepository
    
    public init(log: LogRepository) {
        self.log = log
    }
}

public extension AuthorRealmCache {
    
    func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            guard let object = realm.object(ofType: AuthorRealmObject.self, forPrimaryKey: request.id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = Author(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

public extension AuthorRealmCache {
    
    func createOrUpdate(_ request: Author, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
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
                    realm.add(AuthorRealmObject(from: request), update: .modified)
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            // Get refreshed object to return
            guard let object = realm.object(ofType: AuthorRealmObject.self, forPrimaryKey: request.id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = Author(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

public extension AuthorRealmCache {
    
    func subscribe(
        with request: AuthorAPI.FetchRequest,
        in cancellable: inout Cancellable?,
        change block: @escaping (ChangeResult<Author, SwiftyPressError>) -> Void
    ) {
        DispatchQueue.database.sync {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                self.log.error("An error occured while creating a Realm instance", error: error)
                DispatchQueue.main.async { block(.failure(.cacheFailure(error))) }
                return
            }
            
            cancellable = realm.objects(AuthorRealmObject.self)
                .filter("id == %@", request.id)
                .observe { changes in
                    switch changes {
                    case .initial(let list):
                        guard let element = list.first else { return }
                        self.log.debug("Author with id '\(request.id)' was initialized from cache")
                        
                        let item = Author(from: element)
                        
                        DispatchQueue.main.async {
                            block(.initial(item))
                        }
                    case .update(let list, let deletions, let insertions, let modifications):
                        guard deletions.isEmpty else {
                            self.log.debug("Author with id '\(request.id)' was deleted from cache")
                            DispatchQueue.main.async { block(.failure(.nonExistent)) }
                            return
                        }
                        
                        guard let element = list.first else { return }
                        
                        let debugAction = !insertions.isEmpty ? "added" : !modifications.isEmpty ? "updated" : "unmodified"
                        self.log.debug("Author with id '\(request.id)' was \(debugAction) in cache")
                        
                        let item = Author(from: element)
                        
                        DispatchQueue.main.async {
                            block(.update(item))
                        }
                    case .error(let error):
                        self.log.error("An error occured while observing the Realm instance", error: error)
                        DispatchQueue.main.async { block(.failure(.cacheFailure(error))) }
                    }
                }
        }
    }
}
