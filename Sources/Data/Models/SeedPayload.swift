//
//  SeedPayload.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

public struct SeedPayload: SeedPayloadType, Decodable {
    public let posts: [PostType]
    public let authors: [AuthorType]
    public let media: [MediaType]
    public let categories: [TermType]
    public let tags: [TermType]
    
    init(
        posts: [PostType] = [],
        authors: [AuthorType] = [],
        media: [MediaType] = [],
        categories: [TermType] = [],
        tags: [TermType] = []
    ) {
        self.posts = []
        self.authors = []
        self.media = []
        self.categories = []
        self.tags = []
    }
}

// MARK: - For JSON decoding

extension SeedPayload {
    
    private enum CodingKeys: String, CodingKey {
        case posts
        case authors
        case media
        case categories
        case tags
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.posts = try container.decode(FailableCodableArray<Post>.self, forKey: .posts).elements
        self.authors = try container.decode(FailableCodableArray<Author>.self, forKey: .authors).elements
        self.media = try container.decode(FailableCodableArray<Media>.self, forKey: .media).elements
        self.categories = try container.decode(FailableCodableArray<Term>.self, forKey: .categories).elements
        self.tags = try container.decode(FailableCodableArray<Term>.self, forKey: .tags).elements
    }
}
