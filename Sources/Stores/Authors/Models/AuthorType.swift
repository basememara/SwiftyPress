//
//  UserType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//

public protocol AuthorType: Identifiable, Dateable {
    var name: String { get }
    var link: String { get }
    var avatar: String { get }
    var content: String { get }
}
