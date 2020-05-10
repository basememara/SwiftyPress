//
//  Author.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

// MARK: - Protocol

public protocol AuthorType: Dateable {
    var id: Int { get }
    var name: String { get }
    var link: String { get }
    var avatar: String { get }
    var content: String { get }
}

// MARK: - Model

public struct Author: AuthorType, Identifiable, Codable, Equatable {
    public let id: Int
    public let name: String
    public let link: String
    public let avatar: String
    public let content: String
    public let createdAt: Date
    public let modifiedAt: Date
}

// MARK: - Codable

private extension Author {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case link
        case avatar
        case content = "description"
        case createdAt = "created"
        case modifiedAt = "modified"
    }
}

// MARK: - Conversions

extension Author {
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of author type.
    init(from object: AuthorType) {
        self.init(
            id: object.id,
            name: object.name,
            link: object.link,
            avatar: object.avatar,
            content: object.content,
            createdAt: object.createdAt,
            modifiedAt: object.modifiedAt
        )
    }
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of author type.
    init?(from object: AuthorType?) {
        guard let object = object else { return nil }
        self.init(from: object)
    }
}
