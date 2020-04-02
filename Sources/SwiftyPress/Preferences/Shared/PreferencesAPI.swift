//
//  PreferencesAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

extension PreferencesAPI.Keys {
    static let userID = PreferencesAPI.Key<Int?>("userID")
    static let favorites = PreferencesAPI.Key<[Int]?>("favorites")
}
