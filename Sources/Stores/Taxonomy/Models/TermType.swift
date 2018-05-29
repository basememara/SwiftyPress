//
//  TermType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//

public protocol TermType: Identifiable, Dateable {
    var parentID: Int { get set }
    var slug: String { get set }
    var name: String { get set }
    var taxonomy: String { get set }
    var count: Int { get set }
}
