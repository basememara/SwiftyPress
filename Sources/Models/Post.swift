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
    var status: String { get set }
    var type: String { get set }
    var link: String { get set }
    var date: Date? { get set }
    var modified: Date? { get set }
    
    var imageURL: String { get set }
    var imageWidth: Int { get set }
    var imageHeight: Int { get set }
    var thumbnailURL: String { get set }
    var thumbnailWidth: Int { get set }
    var thumbnailHeight: Int { get set }
    
    var author: User? { get set }
    var categories: List<Term> { get }
    var tags: List<Term> { get }
    
    var viewCount: Int { get set }
    var commentCount: Int { get set }
}

public class Post: Object, Postable {
    
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
    
    public dynamic var imageURL = ""
    public dynamic var imageWidth = 0
    public dynamic var imageHeight = 0
    public dynamic var thumbnailURL = ""
    public dynamic var thumbnailWidth = 0
    public dynamic var thumbnailHeight = 0
    
    public dynamic var viewCount = 0
    public dynamic var commentCount = 0
    
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
            "date",
            "viewCount",
            "commentCount"
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
        
        imageURL = json[.imageURL]
        imageWidth = json[.imageWidth]
        imageHeight = json[.imageHeight]
        thumbnailURL = json[.thumbnailURL]
        thumbnailWidth = json[.thumbnailWidth]
        thumbnailHeight = json[.thumbnailHeight]
        
        viewCount = json[.viewCount]
        commentCount = json[.commentCount]
        
        author = User(json: json[.author])
        categories = List<Term>(json[.category].map(Term.init))
        tags = List<Term>(json[.tag].map(Term.init))
    }
}
