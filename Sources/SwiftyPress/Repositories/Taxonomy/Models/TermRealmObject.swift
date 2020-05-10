//
//  TermRealmObject.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-17.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import RealmSwift

@objcMembers
class TermRealmObject: Object, TermType {
    dynamic var id: Int = 0
    dynamic var parentID: Int = 0
    dynamic var slug: String = ""
    dynamic var name: String = ""
    dynamic var content: String?
    dynamic var taxonomyRaw: String = Taxonomy.category.rawValue
    dynamic var count: Int = 0
    
    override static func primaryKey() -> String? {
        "id"
    }
    
    override static func indexedProperties() -> [String] {
        ["slug", "taxonomy"]
    }
}

// MARK: - Workarounds

extension TermRealmObject {
    
    var taxonomy: Taxonomy {
        get { Taxonomy(rawValue: taxonomyRaw) ?? .category }
        set { taxonomyRaw = newValue.rawValue }
    }
}

// MARK: - Conversions

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
        self.content = object.content
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
