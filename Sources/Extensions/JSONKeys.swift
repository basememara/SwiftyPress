//
//  JSONKeys.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/2/16.
//
//

import JASON

extension JSONKeys {
    static let id = JSONKey<Int>("ID")
    static let slug = JSONKey<String>("slug")
    static let parent = JSONKey<Int>("parent")
    
    static let title = JSONKey<String>("title")
    static let content = JSONKey<String>("content")
    static let description = JSONKey<String>("description")
    static let link = JSONKey<String>("link")
    static let email = JSONKey<String>("email")
    
    static let excerpt = JSONKey<String>("excerpt")
    static let status = JSONKey<String>("status")
    static let type = JSONKey<String>("type")
    static let date = JSONKey<NSDate?>("date")
    static let modified = JSONKey<NSDate?>("modified")
    
    static let favorite = JSONKey<Bool>("favorite")
    static let read = JSONKey<Bool>("read")
    static let viewCount = JSONKey<Int>("view_count")
    static let commentCount = JSONKey<Int>(path: "comment_count", "approved")
    static let menuOrder = JSONKey<Int>("menuOrder")
        
    static let username = JSONKey<String>("username")
    static let name = JSONKey<String>("name")
    static let url = JSONKey<String>("url")
    static let avatar = JSONKey<String>("avatar")
    static let registered = JSONKey<NSDate?>("registered")
    static let isAdmin = JSONKey<Bool>("isAdmin")
    
    static let taxonomy = JSONKey<String>("taxonomy")
    static let count = JSONKey<Int>("count")

    static let imageURL = JSONKey<String>(path: "featured_image", "source")
    static let imageWidth = JSONKey<Int>(path: "featured_image", "attachment_meta", "width")
    static let imageHeight = JSONKey<Int>(path: "featured_image", "attachment_meta", "height")
    static let thumbnailURL = JSONKey<String>(path: "featured_image", "attachment_meta", "sizes", "thumbnail", "url")
    static let thumbnailWidth = JSONKey<Int>(path: "featured_image", "attachment_meta", "sizes", "thumbnail", "width")
    static let thumbnailHeight = JSONKey<Int>(path: "featured_image", "attachment_meta", "sizes", "thumbnail", "height")
    
    static let author = JSONKey<JSON>("author")
    static let category = JSONKey<JSON>(path: "terms", "category")
    static let tag = JSONKey<JSON>(path: "terms", "post_tag")
}