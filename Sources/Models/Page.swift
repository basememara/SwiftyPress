//
//  Page.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/7/16.
//
//

import Foundation
import RealmSwift
import ZamzamKit
import JASON

public protocol Pageable: class {
    
    var id: Int { get set }
    var title: String { get set }
    var content: String { get set }
    var excerpt: String { get set }
    var slug: String { get set }
    var status: String { get set }
    var type: String { get set }
    var link: String { get set }
    var date: Date? { get set }
    var modified: Date? { get set }
    var menuOrder: Int { get set }
    var parent: Int { get set }
    var author: User? { get set }
}

public class Page: Object, Pageable {
    
    public dynamic var id = 0
    public dynamic var title = ""
    public dynamic var content = ""
    public dynamic var excerpt = ""
    public dynamic var slug = ""
    public dynamic var status = ""
    public dynamic var type = ""
    public dynamic var link = ""
    public dynamic var date: Date?
    public dynamic var modified: Date?
    public dynamic var menuOrder = 0
    public dynamic var parent = 0
    public dynamic var author: User?
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    public override static func indexedProperties() -> [String] {
        return [
            "title",
            "slug",
            "menuOrder",
            "parent"
        ]
    }
    
    public convenience init(json: JSON) {
        self.init()
        
        id = json[.id]
        title = json[.title]
        content = json[.content]
        excerpt = json[.excerpt]
        slug = json[.slug]
        status = json[.status]
        type = json[.type]
        link = json[.link]
        date = json[.date]
        modified = json[.modified]
        menuOrder = json[.menuOrder]
        parent = json[.parent]
        author = User(json: json[.author])
    }
}
