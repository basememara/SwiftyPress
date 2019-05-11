//
//  SeedPayloadType.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

public protocol SeedPayloadType {
    var posts: [PostType] { get }
    var categories: [TermType] { get }
    var tags: [TermType] { get }
    var authors: [AuthorType] { get }
    var media: [MediaType] { get }
}

public extension SeedPayloadType {
    
    /// A Boolean value indicating whether the instance is empty.
    var isEmpty: Bool {
        return posts.isEmpty
            && authors.isEmpty
            && media.isEmpty
            && categories.isEmpty
            && tags.isEmpty
    }
}
