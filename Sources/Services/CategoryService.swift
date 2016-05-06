//
//  CategoryService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation

public struct CategoryService {

    /**
     Retrieves categories from user defaults

     - returns: Returns tuple of categories
     */
    public static var storedItems: [(id: Int, title: String, icon: String?)] = {
        AppGlobal.userDefaults[.categories].flatMap {
            guard let id = Int($0["id"] as? String ?? ""),
                let title = $0["title"] as? String
                    else { return nil }
            
            return (id, title, $0["icon"] as? String)
        }
    }()
}