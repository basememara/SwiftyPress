//
//  PostType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public protocol PostType: Dateable {
    var id: Int { get }
    var slug: String { get }
    var type: String { get }
    var title: String { get }
    var content: String { get }
    var excerpt: String { get }
    var link: String { get }
    var commentCount: Int { get }
    var authorID: Int { get }
    var mediaID: Int? { get }
    var terms: [Int] { get }
    var meta: [String: String] { get }
}
