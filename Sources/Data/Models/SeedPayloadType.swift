//
//  SeedPayloadType.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

public protocol SeedPayloadType {
    associatedtype P: PostType
    associatedtype T: TermType
    associatedtype A: AuthorType
    associatedtype M: MediaType
    
    var posts: [P] { get }
    var categories: [T] { get }
    var tags: [T] { get }
    var authors: [A] { get }
    var media: [M] { get }
}
