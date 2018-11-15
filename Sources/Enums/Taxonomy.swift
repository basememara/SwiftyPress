//
//  Taxonomy.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-02.
//

public enum Taxonomy: String, Decodable {
    case category = "category"
    case tag = "post_tag"
}

public extension Taxonomy {
    
    var localized: String {
        switch self {
        case .category: return .localized(.categorySection)
        case .tag: return .localized(.tagSection)
        }
    }
}
