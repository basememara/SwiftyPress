//
//  SeedPayloadType.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

public protocol SeedPayloadType {
    associatedtype PostModel: PostType
    associatedtype TermModel: TermType
    associatedtype AuthorModel: AuthorType
    associatedtype MediaModel: MediaType
    
    var posts: [PostModel] { get }
    var categories: [TermModel] { get }
    var tags: [TermModel] { get }
    var authors: [AuthorModel] { get }
    var media: [MediaModel] { get }
}
