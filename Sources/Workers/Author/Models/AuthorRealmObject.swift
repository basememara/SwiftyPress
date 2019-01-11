//
//  AuthorRealmObject.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-17.
//

import Foundation
import RealmSwift

@objcMembers
class AuthorRealmObject: Object, AuthorType {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var link: String = ""
    dynamic var avatar: String = ""
    dynamic var content: String = ""
    dynamic var createdAt: Date = .distantPast
    dynamic var modifiedAt: Date = .distantPast
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension AuthorRealmObject {
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of author type.
    convenience init(from object: AuthorType) {
        self.init()
        self.id = object.id
        self.name = object.name
        self.link = object.link
        self.avatar = object.avatar
        self.content = object.content
        self.createdAt = object.createdAt
        self.modifiedAt = object.modifiedAt
    }
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of author type.
    convenience init?(from object: AuthorType?) {
        guard let object = object else { return nil }
        self.init(from: object)
    }
}
