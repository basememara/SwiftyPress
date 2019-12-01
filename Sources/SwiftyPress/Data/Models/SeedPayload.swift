//
//  SeedPayload.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct SeedPayload: SeedPayloadType, Decodable {
    public let posts: [PostType]
    public let authors: [AuthorType]
    public let media: [MediaType]
    public let terms: [TermType]
    
    init(
        posts: [PostType] = [],
        authors: [AuthorType] = [],
        media: [MediaType] = [],
        terms: [TermType] = []
    ) {
        self.posts = posts
        self.authors = authors
        self.media = media
        self.terms = terms
    }
}

// MARK: - For JSON decoding

extension SeedPayload {
    
    private enum CodingKeys: String, CodingKey {
        case posts
        case authors
        case media
        case terms
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.posts = try container.decode([Post].self, forKey: .posts)
        self.authors = try container.decode([Author].self, forKey: .authors)
        self.media = try container.decode([Media].self, forKey: .media)
        self.terms = try container.decode([Term].self, forKey: .terms)
    }
}
