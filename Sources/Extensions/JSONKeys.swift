//
//  JSONKeys.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/2/16.
//
//

import JASON

extension JSONKeys {
    static let ID = JSONKey<Int>("ID")
    static let slug = JSONKey<String>("slug")
    
    static let title = JSONKey<String>("title")
    static let content = JSONKey<String>("content")
    static let description = JSONKey<String>("description")
    static let link = JSONKey<String>("link")
    
    static let excerpt = JSONKey<String>("excerpt")
    static let status = JSONKey<String>("status")
    static let type = JSONKey<String>("type")
    static let date = JSONKey<NSDate?>("date")
    static let modified = JSONKey<NSDate?>("modified")
    
    static let username = JSONKey<String>("username")
    static let name = JSONKey<String>("name")
    static let nickname = JSONKey<String>("nickname")
    static let URL = JSONKey<String>("URL")
    static let avatar = JSONKey<String>("avatar")
    static let registered = JSONKey<NSDate?>("registered")
    
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