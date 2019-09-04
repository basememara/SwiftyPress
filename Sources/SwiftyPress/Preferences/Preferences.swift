//
//  PreferencesWorker.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

public extension PreferencesType {
    
    /// Returns the current user's ID, or nil if an anonymous user.
    var userID: Int? {
        return get(.userID)
    }
    
    /// Returns the current favorite posts.
    var favorites: [Int] {
        return get(.favorites) ?? []
    }
    
    /// Removes all the user defaults items.
    func removeAll() {
        remove(.userID)
        remove(.favorites)
    }
}
