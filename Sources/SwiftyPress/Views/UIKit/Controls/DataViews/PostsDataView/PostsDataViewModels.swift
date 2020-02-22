//
//  PostsDataViewModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import Foundation

public struct PostsDataViewModel {
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
    
    init(from object: PostType, mediaURL: String?, favorite: Bool? = nil, dateFormatter: DateFormatter) {
        self.id = object.id
        self.title = object.title
        self.summary = !object.excerpt.isEmpty ? object.excerpt
            : object.content.htmlStripped.htmlDecoded.prefix(150).string
        self.content = object.content
        self.link = object.link
        self.date = dateFormatter.string(from: object.createdAt)
        self.imageURL = mediaURL
        self.favorite = favorite
    }
}

public protocol PostsDataViewCell {
    func bind(_ model: PostsDataViewModel)
    func bind(_ model: PostsDataViewModel, delegate: PostsDataViewDelegate?)
}

public extension PostsDataViewCell {
    
    func bind(_ model: PostsDataViewModel, delegate: PostsDataViewDelegate?) {
        bind(model)
    }
}
#endif
