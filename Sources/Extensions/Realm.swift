//
//  Realm.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2/13/17.
//
//

import Foundation
import RealmSwift

extension Realm {

    /// Retrieves the instances of a given object type with the given primary keys from the Realm.
    ///
    /// - Parameters:
    ///   - type: The type of the objects to be returned.
    ///   - keys: The primary keys of the desired objects.
    /// - Returns: A Results containing the objects.
    func objects<T: Object, K: Any>(_ ofType: T.Type, forPrimaryKeys: [K]) -> Results<T> {
        return objects(ofType).filter("\(ofType.primaryKey) IN %@", forPrimaryKeys)
    }
}
