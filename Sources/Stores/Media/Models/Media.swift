//
//  Media.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

public struct Media: MediaType, Decodable {
    public let id: Int
    public let link: String
    public let width: Int
    public let height: Int
    public let thumbnailLink: String
    public let thumbnailWidth: Int
    public let thumbnailHeight: Int
}

// MARK: - For JSON decoding

private extension Media {
    
    enum CodingKeys: String, CodingKey {
        case id
        case link
        case width
        case height
        case thumbnailLink = "thumbnail_link"
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
    }
}
