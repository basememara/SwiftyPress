//
//  AuthorsRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//

import ZamzamKit
import RealmSwift

public struct AuthorsRealmStore: AuthorsStore, Loggable {
    
}

public extension AuthorsRealmStore {
    
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            guard let object = realm.object(ofType: AuthorRealmObject.self, forPrimaryKey: id) else {
                return DispatchQueue.main.async { completion(.failure(.nonExistent)) }
            }
            
            let item = Author(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}
