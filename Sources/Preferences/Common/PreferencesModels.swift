//
//  UserDefaults.Keys.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

extension UserDefaults.Keys {
    static let userID = UserDefaults.Key<Int?>("userID")
    static let favorites = UserDefaults.Key<[Int]?>("favorites")
}
