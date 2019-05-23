//
//  PostsModels.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-30.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public enum PostsModels {
    
    public struct FetchRequest {
        let taxonomies: [String]
        let postMetaKeys: [String]
    }
    
    public enum SearchScope {
        case all
        case title
        case content
        case terms
    }
    
    public struct SearchRequest {
        let query: String
        let scope: SearchScope
        
        public init(query: String, scope: SearchScope) {
            self.query = query
            self.scope = scope
        }
    }
}
