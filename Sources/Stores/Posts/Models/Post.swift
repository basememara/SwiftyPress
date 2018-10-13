//
//  Post.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-05-30.
//

public struct Post: PostType, Decodable {
    public let id: Int
    public let slug: String
    public let type: String
    public let title: String
    public let content: String
    public let excerpt: String
    public let link: String
    public let commentCount: Int
    public let authorID: Int
    public let mediaID: Int?
    public let categories: [Int]
    public let tags: [Int]
    public let createdAt: Date
    public let modifiedAt: Date
}

// MARK: - For JSON decoding

private extension Post {
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case type
        case title
        case content
        case excerpt
        case link
        case commentCount = "comment_count"
        case authorID = "author"
        case mediaID = "featured_media"
        case categories
        case tags
        case createdAt = "created"
        case modifiedAt = "modified"
    }
}

/// Post type used for decoding the server payload
public struct ExpandedPost: Decodable {
    public let post: Post
    public let categories: [Term]
    public let tags: [Term]
    public let author: Author?
    public let media: Media?
}
