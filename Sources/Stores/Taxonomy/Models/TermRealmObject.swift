//
//  TermRealmObject.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-17.
//

import Foundation
import RealmSwift

@objcMembers
class TermRealmObject: Object, TermType {
    dynamic var id: Int = 0
    dynamic var parentID: Int = 0
    dynamic var slug: String = ""
    dynamic var name: String = ""
    dynamic var taxonomyRaw: String = Taxonomy.category.rawValue
    dynamic var count: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return [
            "slug",
            "taxonomy"
        ]
    }
}

// MARK: - Workarounds for special types

extension TermRealmObject {
    
    var taxonomy: Taxonomy {
        get { return Taxonomy(rawValue: taxonomyRaw) ?? .category }
        set { taxonomyRaw = newValue.rawValue }
    }
}

extension TermRealmObject {
    
    /// For converting to one type to another
    ///
    /// - Parameter object: An instance of term type.
    convenience init(from object: TermType) {
        self.init()
        self.id = object.id
        self.parentID = object.parentID
        self.slug = object.slug
        self.name = object.name
        self.taxonomy = object.taxonomy
        self.count = object.count
    }
    
    /// For converting to one type to another
    ///
    /// - Parameter object: An instance of term type.
    convenience init?(from object: TermType?) {
        guard let object = object else { return nil }
        self.init(from: object)
    }
}
