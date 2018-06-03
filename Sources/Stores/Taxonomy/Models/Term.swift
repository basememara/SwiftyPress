//
//  Term.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

public struct Term: TermType {
    public let id: Int
    public let parentID: Int
    public let slug: String
    public let name: String
    public let taxonomy: Taxonomy
    public let count: Int
    public let createdAt: Date
    public let modifiedAt: Date
}
