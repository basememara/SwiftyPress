//
//  AuthorsRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//

import ZamzamKit
import RealmSwift

public struct AuthorRealmStore: AuthorStore, Loggable {
    
}

public extension AuthorRealmStore {
    
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            guard let object = realm.object(ofType: AuthorRealmObject.self, forPrimaryKey: id) else {
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
