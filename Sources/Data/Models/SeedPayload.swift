//
//  SeedPayload.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public struct SeedPayload: SeedPayloadType, Decodable {
    public let posts: [Post]
    public let authors: [Author]
    public let media: [Media]
    public let categories: [Term]
    public let tags: [Term]
    
    init(
        posts: [Post] = [],
        authors: [Author] = [],
        media: [Media] = [],
        categories: [Term] = [],
        tags: [Term] = []
    ) {
        self.posts = []
        self.authors = []
        self.media = []
        self.categories = []
        self.tags = []
    }
}

public extension SeedPayload {
    
    /// A Boolean value indicating whether the instance is empty.
    var isEmpty: Bool {
        return posts.isEmpty
            && authors.isEmpty
            && media.isEmpty
            && categories.isEmpty
            && tags.isEmpty
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
