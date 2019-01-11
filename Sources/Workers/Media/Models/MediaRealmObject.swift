//
//  MediaRealmObject.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-17.
//

import Foundation
import RealmSwift

@objcMembers
class MediaRealmObject: Object, MediaType {
    dynamic var id: Int = 0
    dynamic var link: String = ""
    dynamic var width: Int = 0
    dynamic var height: Int = 0
    dynamic var thumbnailLink: String = ""
    dynamic var thumbnailWidth: Int = 0
    dynamic var thumbnailHeight: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension MediaRealmObject {
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of media type.
    convenience init(from object: MediaType) {
        self.init()
        self.id = object.id
        self.link = object.link
        self.width = object.width
        self.height = object.height
        self.thumbnailLink = object.thumbnailLink
        self.thumbnailWidth = object.thumbnailWidth
        self.thumbnailHeight = object.thumbnailHeight
    }
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of media type.
    convenience init?(from object: MediaType?) {
        guard let object = object else { return nil }
        self.init(from: object)
    }
}
