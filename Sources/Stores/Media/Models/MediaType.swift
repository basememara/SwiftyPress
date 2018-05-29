//
//  MediaType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//

public protocol MediaType: Identifiable {
    var link: String { get set }
    var width: Int { get set }
    var height: Int { get set }
    var thumbnailLink: String { get set }
    var thumbnailWidth: Int { get set }
    var thumbnailHeight: Int { get set }
}
