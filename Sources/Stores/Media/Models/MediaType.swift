//
//  MediaType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//

public protocol MediaType: Identifiable {
    var link: String { get }
    var width: Int { get }
    var height: Int { get }
    var thumbnailLink: String { get }
    var thumbnailWidth: Int { get }
    var thumbnailHeight: Int { get }
}
