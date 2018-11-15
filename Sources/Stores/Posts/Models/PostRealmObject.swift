//
//  PostRealmObject.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-17.
//
import Foundation
import RealmSwift

@objcMembers
class PostRealmObject: Object, PostType {
    dynamic var id: Int = 0
    dynamic var slug: String = ""
    dynamic var type: String = ""
    dynamic var title: String = ""
    dynamic var content: String = ""
    dynamic var excerpt: String = ""
    dynamic var link: String = ""
    dynamic var commentCount: Int = 0
    dynamic var authorID: Int = 0
    dynamic var createdAt: Date = .distantPast
    dynamic var modifiedAt: Date = .distantPast
    
    let mediaIDRaw = RealmOptional<Int>()
    let categoriesRaw = List<TermIDRealmObject>()
    let tagsRaw = List<TermIDRealmObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return [
            "slug"
        ]
    }
}

// MARK: - Workarounds for special types

extension PostRealmObject {
    
    var mediaID: Int? {
        get { return mediaIDRaw.value }
        set { mediaIDRaw.value = newValue }
    }
    
    var categories: [Int] {
        get { return categoriesRaw.map { $0.id } }
        set {
            categoriesRaw.removeAll()
            categoriesRaw.append(objectsIn: newValue.map { id in
                TermIDRealmObject().with { $0.id = id }
            })
        }
    }
    
    var tags: [Int] {
        get { return tagsRaw.map { $0.id } }
        set {
            tagsRaw.removeAll()
            tagsRaw.append(objectsIn: newValue.map { id in
                TermIDRealmObject().with { $0.id = id }
            })
        }
    }
}

/// Dummy type since no support for queries of array of primitives
@objcMembers
class TermIDRealmObject: Object {
    // https://github.com/realm/realm-object-store/issues/513
    dynamic var id: Int = 0
    override static func primaryKey() -> String? { return "id" }
}

// MARK: - Helpers

extension PostRealmObject {
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of post type.
    convenience init(from object: PostType) {
        self.init()
        self.id = object.id
        self.slug = object.slug
        self.type = object.type
        self.title = object.title
        self.content = object.content
        self.excerpt = object.excerpt
        self.link = object.link
        self.commentCount = object.commentCount
        self.authorID = object.authorID
        self.mediaID = object.mediaID
        self.categories = object.categories
        self.tags = object.tags
        self.createdAt = object.createdAt
        self.modifiedAt = object.modifiedAt
    }
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of post type.
    convenience init?(from object: PostType?) {
        guard let object = object else { return nil }
        self.init(from: object)
    }
}
