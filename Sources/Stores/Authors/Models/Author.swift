//
//  Author.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

public struct Author: AuthorType {
    public let id: Int
    public let name: String
    public let link: String
    public let avatar: String
    public let content: String
    public let createdAt: Date
    public let modifiedAt: Date
}
