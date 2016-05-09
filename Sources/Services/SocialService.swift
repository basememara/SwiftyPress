//
//  SocialService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation

public struct SocialService {

    /**
     Retrieves categories from user defaults

     - returns: Returns tuple of categories
     */
    public static var storedItems: [(title: String?, link: String?, icon: String?, app: String?)] = {
        AppGlobal.userDefaults[.social].flatMap {
            guard let link = $0["link"] as? String where !link.isEmpty else { return nil }
            return ($0["title"] as? String, link, $0["icon"] as? String, $0["app"] as? String)
        }
    }()
}