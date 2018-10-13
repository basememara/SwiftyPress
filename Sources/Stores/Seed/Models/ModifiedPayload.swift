//
//  ModifiedPayload.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public struct ModifiedPayload: ModifiedPayloadType, Decodable {
    public let posts: [Post]
    public let categories: [Term]
    public let tags: [Term]
    public let authors: [Author]
    public let media: [Media]
    
    init(
        posts: [Post] = [],
        categories: [Term] = [],
        tags: [Term] = [],
        authors: [Author] = [],
        media: [Media] = [])
    {
        self.posts = []
        self.categories = []
        self.tags = []
        self.authors = []
        self.media = []
    }
}

public extension ModifiedPayload {
    
    /// A Boolean value indicating whether the instance is empty.
    var isEmpty: Bool {
        return posts.isEmpty
            && categories.isEmpty
            && tags.isEmpty
            && authors.isEmpty
            && media.isEmpty
    }
}

// MARK: - For JSON decoding

extension ModifiedPayload {
    
    private enum CodingKeys: String, CodingKey {
        case posts
        case categories
        case tags
        case authors
        case media
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.posts = try container.decode(FailableCodableArray<Post>.self, forKey: .posts).elements
        self.categories = try container.decode(FailableCodableArray<Term>.self, forKey: .categories).elements
        self.tags = try container.decode(FailableCodableArray<Term>.self, forKey: .tags).elements
        self.authors = try container.decode(FailableCodableArray<Author>.self, forKey: .authors).elements
        self.media = try container.decode(FailableCodableArray<Media>.self, forKey: .media).elements
    }
}
