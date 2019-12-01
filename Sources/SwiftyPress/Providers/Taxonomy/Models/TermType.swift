//
//  TermType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public protocol TermType: Identifiable {
    var parentID: Int { get }
    var slug: String { get }
    var name: String { get }
    var content: String? { get }
    var taxonomy: Taxonomy { get }
    var count: Int { get }
}
