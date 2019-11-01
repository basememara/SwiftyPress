//
//  TaxonomyRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import RealmSwift
import ZamzamCore

public struct TaxonomyRealmStore: TaxonomyStore {
    private let log: LogWorkerType
    
    public init(log: LogWorkerType) {
        self.log = log
    }
}

public extension TaxonomyRealmStore {
    
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            guard let object = realm.object(ofType: TermRealmObject.self, forPrimaryKey: id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = Term(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            guard let object = realm.objects(TermRealmObject.self).filter("slug == %@", slug).first else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = Term(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

public extension TaxonomyRealmStore {
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [TermType] = realm.objects(TermRealmObject.self)
                .filter("count > 0")
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension TaxonomyRealmStore {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [TermType] = realm.objects(TermRealmObject.self, forPrimaryKeys: ids)
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            guard !items.isEmpty else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [TermType] = realm.objects(TermRealmObject.self)
                .filter("taxonomyRaw == %@ && count > 0", taxonomy.rawValue)
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetch(by taxonomies: [Taxonomy], completion: @escaping (Result<[TermType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [TermType] = realm.objects(TermRealmObject.self)
                .filter("taxonomyRaw IN %@ && count > 0", taxonomies.map { $0.rawValue })
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension TaxonomyRealmStore {
    
    func getID(bySlug slug: String) -> Int? {
        let realm: Realm
        
        do {
            realm = try Realm()
        } catch {
            return nil
        }
        
        return realm.objects(TermRealmObject.self)
            .filter("slug == %@", slug)
            .first?
            .id
    }
}
