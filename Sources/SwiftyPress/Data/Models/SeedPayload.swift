//
//  SeedPayload.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct SeedPayload: Codable, Equatable {
    public let posts: [Post]
    public let authors: [Author]
    public let media: [Media]
    public let terms: [Term]
    
    init(
        posts: [Post] = [],
        authors: [Author] = [],
        media: [Media] = [],
        terms: [Term] = []
    ) {
        self.posts = posts
        self.authors = authors
        self.media = media
        self.terms = terms
    }
}

public extension SeedPayload {
    
    /// A Boolean value indicating whether the instance is empty.
    var isEmpty: Bool {
        posts.isEmpty
            && authors.isEmpty
            && media.isEmpty
            && terms.isEmpty
    }
}
