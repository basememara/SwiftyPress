//
//  PostsModels.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-30.
//

public enum PostsModels {
    
    public enum SearchScope {
        case all
        case title
        case content
        case terms
    }
    
    public struct SearchRequest {
        public let query: String
        public let scope: SearchScope
    }
}
