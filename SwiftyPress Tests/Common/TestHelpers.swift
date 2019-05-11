//
//  TestHelpers.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest

extension UserDefaults {
    static let test = UserDefaults(suiteName: Bundle.test.bundleIdentifier!)!
}

extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in bundle directory on disk.
    static let test = Bundle(for: TempClassForBundle.self)
}
