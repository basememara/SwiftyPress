//
//  ExtendedPost.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

// Type used for decoding the server payload
public struct ExtendedPost: Codable, Equatable {
    public let post: Post
    public let author: Author?
    public let media: Media?
    public let terms: [Term]
}

// MARK: - Codable

extension ExtendedPost {
    
    private enum CodingKeys: String, CodingKey {
        case post
        case author
        case media
        case terms
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.post = try container.decode(Post.self, forKey: .post)
        self.author = try container.decode(Author.self, forKey: .author)
        self.media = try container.decode(Media.self, forKey: .media)
        self.terms = try container.decode(FailableCodableArray<Term>.self, forKey: .terms).elements
    }
}
