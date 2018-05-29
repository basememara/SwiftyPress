//
//  Dateable.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

public protocol Dateable: Equatable {
    var createdAt: Date { get }
    var modifiedAt: Date { get }
}
