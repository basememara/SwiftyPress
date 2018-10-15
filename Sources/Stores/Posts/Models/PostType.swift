//
//  PostType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//

public protocol PostType: Identifiable, Dateable {
    var slug: String { get }
    var type: String { get }
    var title: String { get }
    var content: String { get }
    var excerpt: String { get }
    var link: String { get }
    var commentCount: Int { get }
    var authorID: Int { get }
    var mediaID: Int? { get }
    var categories: [Int] { get }
    var tags: [Int] { get }
}

/// Post type used for grouping multiple protocols
public struct ExpandedPostType {
    public let post: PostType
    public let categories: [TermType]
    public let tags: [TermType]
    public let author: AuthorType?
    public let media: MediaType?
    
    init(
        post: PostType,
        categories: [TermType],
        tags: [TermType],
        author: AuthorType?,
        media: MediaType?)
    {
        self.post = post
        self.categories = categories
        self.tags = tags
        self.author = author
        self.media = media
    }
    
    init(from object: ExpandedPost) {
        self.post = object.post
        self.categories = object.categories
        self.tags = object.tags
        self.author = object.author
        self.media = object.media
    }
}
