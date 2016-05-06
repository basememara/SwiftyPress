//
//  MenuService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation

public struct MenuService {

    /**
     Retrieves more menu from user defaults

     - returns: Returns tuple of menu items
     */
    public static var storedMoreItems: [(title: String?, link: String?, icon: String?)] = {
        AppGlobal.userDefaults[.moreMenu].map {
            ($0["title"] as? String, $0["link"] as? String, $0["icon"] as? String)
        }
    }()
}