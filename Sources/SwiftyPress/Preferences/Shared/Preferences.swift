//
//  Preferences.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

public extension Preferences {
    
    /// Returns the current user's ID, or nil if an anonymous user.
    var userID: Int? { self.get(.userID) }
    
    /// Returns the current favorite posts.
    var favorites: [Int] { self.get(.favorites) ?? [] }
}

// MARK: - Mutating

extension Preferences {
    
    func set(userID value: Int) {
        set(value, forKey: .userID)
    }
    
    func set(favorites value: [Int]) {
        set(value, forKey: .favorites)
    }
    
    /// Removes all the user defaults items.
    func removeAll() {
        remove(.userID)
        remove(.favorites)
    }
}

// MARK: - Helpers

private extension PreferencesAPI.Keys {
    static let userID = PreferencesAPI.Key<Int?>("userID")
    static let favorites = PreferencesAPI.Key<[Int]?>("favorites")
}
