//
//  UserType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//

public protocol AuthorType: Identifiable, Dateable {
    var name: String { get set }
    var link: String { get set }
    var avatar: String { get set }
    var content: String { get set }
}
