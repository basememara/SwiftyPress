//
//  PostPayload.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-20.
//

import Foundation

/// Post type used for grouping multiple protocols
public struct PostPayloadType {
    public let post: PostType
    public let author: AuthorType?
    public let media: MediaType?
    public let categories: [TermType]
    public let tags: [TermType]
    
    init(
        post: PostType,
        author: AuthorType?,
        media: MediaType?,
        categories: [TermType],
        tags: [TermType])
    {
        self.post = post
        self.author = author
        self.media = media
        self.categories = categories
        self.tags = tags
    }
    
    init(from object: PostPayload) {
        self.post = object.post
        self.author = object.author
        self.media = object.media
        self.categories = object.categories
        self.tags = object.tags
    }
}

/// Post type used for decoding the server payload
public struct PostPayload: Decodable {
    public let post: Post
    public let author: Author?
    public let media: Media?
    public let categories: [Term]
    public let tags: [Term]
}
