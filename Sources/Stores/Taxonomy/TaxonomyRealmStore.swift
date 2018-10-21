//
//  TaxonomyRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//

import ZamzamKit
import RealmSwift

public struct TaxonomyRealmStore: TaxonomyStore, Loggable {
    
}

public extension TaxonomyRealmStore {
    
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            guard let object = realm.object(ofType: TermRealmObject.self, forPrimaryKey: id) else {
                return DispatchQueue.main.async { completion(.failure(.nonExistent)) }
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
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            guard let object = realm.objects(TermRealmObject.self).filter("slug == %@", slug).first else {
                return DispatchQueue.main.async { completion(.failure(.nonExistent)) }
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
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
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
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [TermType] = realm.objects(TermRealmObject.self, forPrimaryKeys: ids)
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do { realm = try Realm() }
            catch { return DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) } }
            
            let items: [TermType] = realm.objects(TermRealmObject.self)
                .filter("taxonomyRaw == %@ && count > 0", taxonomy.rawValue)
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}
