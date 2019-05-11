//
//  Realm.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-17.
//

import RealmSwift

extension Realm {
    
    /// Adds or updates an optional object into the Realm.
    ///
    /// - Parameters:
    ///   - object: The object to be added to this Realm.
    ///   - update: If `true`, the Realm will try to find
    ///     an existing copy of the object (with the same
    ///     primary key), and update it. Otherwise, the
    ///     object will be added.
    func add(_ object: Object?, update: Bool = false) {
        guard let object = object else { return }
        add(object, update: update)
    }
}

extension Realm {
    
    /// Retrieves the instances of a given object type with the given primary keys from the Realm.
    ///
    /// - Parameters:
    ///   - type: The type of the objects to be returned.
    ///   - keys: The primary keys of the desired objects.
    /// - Returns: A Results containing the objects.
    func objects<T: Object, K: Any>(_ ofType: T.Type, forPrimaryKeys: Set<K>) -> Results<T> {
        guard let primaryKey = ofType.primaryKey() else {
            // Create empty set
            return objects(ofType).filter(NSPredicate(value: false))
        }
        
        return objects(ofType).filter("\(primaryKey) IN %@", forPrimaryKeys)
    }
}
