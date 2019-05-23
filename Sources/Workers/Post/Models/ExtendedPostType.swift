//
//  ExtendedPostType.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

/// Post type used for grouping multiple types
public protocol ExtendedPostType {
    var post: PostType { get }
    var author: AuthorType? { get }
    var media: MediaType? { get }
    var terms: [TermType] { get }
}
