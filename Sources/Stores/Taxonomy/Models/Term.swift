//
//  Term.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

public struct Term: TermType, Decodable {
    public let id: Int
    public let parentID: Int
    public let slug: String
    public let name: String
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
        case taxonomy
        case count
    }
}
