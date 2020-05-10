//
//  Term.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

// MARK: - Protocol

public protocol TermType {
    var id: Int { get }
    var parentID: Int { get }
    var slug: String { get }
    var name: String { get }
    var content: String? { get }
    var taxonomy: Taxonomy { get }
    var count: Int { get }
}

// MARK: - Model

public struct Term: TermType, Identifiable, Codable, Equatable {
    public let id: Int
    public let parentID: Int
    public let slug: String
    public let name: String
    public let content: String?
    public let taxonomy: Taxonomy
    public let count: Int
}

// MARK: - Codable

private extension Term {
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parent"
        case slug
        case name
        case content
        case taxonomy
        case count
    }
}

// MARK: - Conversions

extension Term {
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of term type.
    init(from object: TermType) {
        self.init(
            id: object.id,
            parentID: object.parentID,
            slug: object.slug,
            name: object.name,
            content: object.content,
            taxonomy: object.taxonomy,
            count: object.count
        )
    }
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of term type.
    init?(from object: TermType?) {
        guard let object = object else { return nil }
        self.init(from: object)
    }
}
