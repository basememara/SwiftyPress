//
//  SeedPayloadType.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public protocol SeedPayloadType {
    var posts: [PostType] { get }
    var terms: [TermType] { get }
    var authors: [AuthorType] { get }
    var media: [MediaType] { get }
}

public extension SeedPayloadType {
    
    /// A Boolean value indicating whether the instance is empty.
    var isEmpty: Bool {
        return posts.isEmpty
            && authors.isEmpty
            && media.isEmpty
            && terms.isEmpty
    }
}
