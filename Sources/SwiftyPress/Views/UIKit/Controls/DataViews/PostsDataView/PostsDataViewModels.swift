//
//  PostsDataViewModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter

public struct PostsDataViewModel: Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let summary: String
    public let content: String
    public let link: String
    public let date: String
    public let imageURL: String?
    public let favorite: Bool?
}

public extension PostsDataViewModel {
    
    func toggled(favorite: Bool) -> Self {
        PostsDataViewModel(
            id: id,
            title: title,
            summary: summary,
            content: content,
            link: link,
            date: date,
            imageURL: imageURL,
            favorite: favorite
        )
    }
}

public extension PostsDataViewModel {
    
    init(from object: PostType, mediaURL: String?, favorite: Bool? = nil, dateFormatter: DateFormatter) {
        self.id = object.id
        self.title = object.title
        self.summary = !object.excerpt.isEmpty ? object.excerpt
            : object.content.htmlStripped.htmlDecoded().prefix(150).string
        self.content = object.content
        self.link = object.link
        self.date = dateFormatter.string(from: object.createdAt)
        self.imageURL = mediaURL
        self.favorite = favorite
    }
}
