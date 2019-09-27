//
//  String.Keys.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

/// Preferences request namespace
public enum PreferencesAPI {}

extension String.Keys {
    static let userID = String.Key<Int?>("userID")
    static let favorites = String.Key<[Int]?>("favorites")
}
