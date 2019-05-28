//
//  PostsModels.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-30.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public enum PostsModels {
    
    public struct FetchRequest {
        let maxLength: Int?
        
        public init(maxLength: Int? = nil) {
            self.maxLength = maxLength
        }
    }
    
    public struct ItemRequest {
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
        let maxLength: Int?
        
        public init(query: String, scope: SearchScope, maxLength: Int? = nil) {
            self.query = query
            self.scope = scope
            self.maxLength = maxLength
        }
    }
}
