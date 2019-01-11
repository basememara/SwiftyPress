//
//  MediaRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//

import ZamzamKit
import RealmSwift

public struct MediaRealmStore: MediaStore, Loggable {
    
}

public extension MediaRealmStore {
    
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            guard let object = realm.object(ofType: MediaRealmObject.self, forPrimaryKey: id) else {
                return DispatchQueue.main.async { completion(.failure(.nonExistent)) }
            }
            
            let item = Media(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

public extension MediaRealmStore {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[MediaType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [MediaType] = realm.objects(MediaRealmObject.self, forPrimaryKeys: ids)
                .map { Media(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}
