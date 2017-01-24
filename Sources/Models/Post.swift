//
//  BlogPostModel.swift
//  ZamzamKitData
//
//  Created by Basem Emara on 3/20/16.
//
//

import Foundation
import RealmSwift
import ZamzamKit
import JASON

public protocol Postable: class {
    
    var id: Int { get set }
    var title: String { get set }
    var content: String { get set }
    var excerpt: String { get set }
    var slug: String { get set }
    var type: String { get set }
    var link: String { get set }
    var date: Date? { get set }
    var modified: Date? { get set }
    var commentCount: Int { get set }
    
    var media: Media? { get set }
    var author: User? { get set }
    var categories: List<Term> { get }
    var tags: List<Term> { get }
}

public class Post: Object, Postable {
    
    public dynamic var id = 0
    public dynamic var title = ""
    public dynamic var content = ""
    public dynamic var excerpt = ""
    public dynamic var slug = ""
    public dynamic var type = ""
    public dynamic var link = ""
    public dynamic var date: Date?
    public dynamic var modified: Date?
    public dynamic var commentCount = 0
    
    public dynamic var media: Media?
    public dynamic var author: User?
    public var categories = List<Term>()
    public var tags = List<Term>()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    public override static func indexedProperties() -> [String] {
        return [
            "title",
            "slug",
            "date"
        ]
    }
    
    public convenience init(json: JSON) {
        self.init()
        
        id = json[.id]
        title = json[.title]
        content = json[.content]
        excerpt = json[.excerpt]
        slug = json[.slug]
        type = json[.type]
        link = json[.link]
        date = json[.date]
        modified = json[.modified]
        commentCount = json[.commentCount]
        
        // Retrieve associated models
        author = User(json: json[.author])
        categories = List<Term>(json[.categories].map(Term.init))
        tags = List<Term>(json[.tags].map(Term.init))
        
        let image = Media(json: json[.media])
        if !image.link.isEmpty {
            media = image
        }
    }
}
