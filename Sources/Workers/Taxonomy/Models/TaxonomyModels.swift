//
//  TaxonomyModels.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-02.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public enum TaxonomyModels {
    
    public struct SearchRequest {
        public let query: String
        public let scope: Taxonomy?
    }
}
