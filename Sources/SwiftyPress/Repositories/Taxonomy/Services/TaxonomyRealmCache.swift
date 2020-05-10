//
//  TaxonomyRealmCache.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import RealmSwift
import ZamzamCore

public struct TaxonomyRealmCache: TaxonomyCache {
    private let log: LogRepository
    
    public init(log: LogRepository) {
        self.log = log
    }
}

public extension TaxonomyRealmCache {
    
    func fetch(id: Int, completion: @escaping (Result<Term, SwiftyPressError>) -> Void) {
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
    
    func fetch(slug: String, completion: @escaping (Result<Term, SwiftyPressError>) -> Void) {
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

public extension TaxonomyRealmCache {
    
    func fetch(completion: @escaping (Result<[Term], SwiftyPressError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [Term] = realm.objects(TermRealmObject.self)
                .filter("count > 0")
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension TaxonomyRealmCache {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Term], SwiftyPressError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [Term] = realm.objects(TermRealmObject.self, forPrimaryKeys: ids)
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
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[Term], SwiftyPressError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [Term] = realm.objects(TermRealmObject.self)
                .filter("taxonomyRaw == %@ && count > 0", taxonomy.rawValue)
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
    
    func fetch(by taxonomies: [Taxonomy], completion: @escaping (Result<[Term], SwiftyPressError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            let items: [Term] = realm.objects(TermRealmObject.self)
                .filter("taxonomyRaw IN %@ && count > 0", taxonomies.map { $0.rawValue })
                .sorted(byKeyPath: "count", ascending: false)
                .map { Term(from: $0) }
            
            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }
}

public extension TaxonomyRealmCache {
    
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
