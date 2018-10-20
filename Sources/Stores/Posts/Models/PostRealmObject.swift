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
    dynamic let mediaIDRaw = RealmOptional<Int>()
    dynamic var categoriesRaw = List<Int>()
    dynamic var tagsRaw = List<Int>()
    dynamic var createdAt: Date = .distantPast
    dynamic var modifiedAt: Date = .distantPast
    
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
        get { return Array(categoriesRaw) }
        set {
            categoriesRaw = List<Int>().with {
                $0.append(objectsIn: newValue)
            }
        }
    }
    
    var tags: [Int] {
        get { return Array(tagsRaw) }
        set {
            tagsRaw = List<Int>().with {
                $0.append(objectsIn: newValue)
            }
        }
    }
}

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

extension Array where Element: PostType {
    
    /// Generates a Realm list of objects.
    func toList() -> List<PostRealmObject> {
        return List<PostRealmObject>().with {
            $0.append(objectsIn: map {
                PostRealmObject(from: $0)
            })
        }
    }
}
