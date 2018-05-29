//
//  PostType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//

public protocol PostType: Identifiable, Dateable {
    var slug: String { get set }
    var type: String { get set }
    var title: String { get set }
    var content: String { get set }
    var excerpt: String { get set }
    var link: String { get set }
    var commentCount: Int { get set }
    var authorID: Int { get set }
    var mediaID: Int? { get set }
    var categories: [Int] { get }
    var tags: [Int] { get }
}
