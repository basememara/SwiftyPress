//
//  JSONKeys.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/2/16.
//
//

import JASON

extension JSONKeys {
    static let id = JSONKey<Int>("id")
    static let slug = JSONKey<String>("slug")
    static let parent = JSONKey<Int>("parent")
    
    static let title = JSONKey<String>("title")
    static let content = JSONKey<String>("content")
    static let description = JSONKey<String>("description")
    static let link = JSONKey<String>("link")
    static let email = JSONKey<String>("email")
    
    static let excerpt = JSONKey<String>("excerpt")
    static let type = JSONKey<String>("type")
    static let date = JSONKey<Date?>("date")
    static let modified = JSONKey<Date?>("modified")
    
    static let commentCount = JSONKey<Int>("comment_count")
        
    static let username = JSONKey<String>("username")
    static let name = JSONKey<String>("name")
    static let url = JSONKey<String>("url")
    static let avatar = JSONKey<String>("avatar")
    
    static let taxonomy = JSONKey<String>("taxonomy")

    static let width = JSONKey<Int>("width")
    static let height = JSONKey<Int>("height")
    static let thumbnailLink = JSONKey<String>("thumbnail_link")
    static let thumbnailWidth = JSONKey<Int>("thumbnail_width")
    static let thumbnailHeight = JSONKey<Int>("thumbnail_height")
    
    static let author = JSONKey<JSON>("author")
    static let media = JSONKey<JSON>("featured_media")
    static let categories = JSONKey<JSON>("categories")
    static let tags = JSONKey<JSON>("tags")
}
