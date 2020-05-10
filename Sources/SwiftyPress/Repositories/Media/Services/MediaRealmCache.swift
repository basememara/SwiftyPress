//
//  MediaRealmCache.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import RealmSwift
import ZamzamCore

public struct MediaRealmCache: MediaCache {
    private let log: LogRepository
    
    public init(log: LogRepository) {
        self.log = log
    }
}

public extension MediaRealmCache {
    
    func fetch(id: Int, completion: @escaping (Result<Media, SwiftyPressError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            guard let object = realm.object(ofType: MediaRealmObject.self, forPrimaryKey: id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = Media(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

public extension MediaRealmCache {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Media], SwiftyPressError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [Media] = realm.objects(MediaRealmObject.self, forPrimaryKeys: ids)
                .map { Media(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension MediaRealmCache {
    
    func createOrUpdate(_ request: Media, completion: @escaping (Result<Media, SwiftyPressError>) -> Void) {
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
                    realm.add(MediaRealmObject(from: request), update: .modified)
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            // Get refreshed object to return
            guard let object = realm.object(ofType: MediaRealmObject.self, forPrimaryKey: request.id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = Media(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}
