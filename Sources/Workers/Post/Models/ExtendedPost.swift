//
//  ExtendedPost.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

// Type used for decoding the server payload
struct ExtendedPost: ExtendedPostType, Decodable {
    let post: PostType
    let author: AuthorType?
    let media: MediaType?
    let categories: [TermType]
    let tags: [TermType]
}

// MARK: - For JSON decoding

extension ExtendedPost {
    
    private enum CodingKeys: String, CodingKey {
        case post
        case author
        case media
        case categories
        case tags
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.post = try container.decode(Post.self, forKey: .post)
        self.author = try container.decode(Author.self, forKey: .author)
        self.media = try container.decode(Media.self, forKey: .media)
        self.categories = try container.decode(FailableCodableArray<Term>.self, forKey: .categories).elements
        self.tags = try container.decode(FailableCodableArray<Term>.self, forKey: .tags).elements
    }
}
