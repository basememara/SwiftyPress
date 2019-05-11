//
//  Term.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct Term: TermType, Decodable {
    public let id: Int
    public let parentID: Int
    public let slug: String
    public let name: String
    public let content: String?
    public let taxonomy: Taxonomy
    public let count: Int
}

// MARK: - For JSON decoding

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
