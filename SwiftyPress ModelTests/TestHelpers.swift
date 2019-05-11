//
//  SwiftyPress_ModelTests.swift
//  SwiftyPress ModelTests
//
//  Created by Basem Emara on 2019-05-11.
//

import XCTest

class TestHelpers {
    static let shared: TestHelpers = TestHelpers()
    
    private(set) lazy var bundleIdentifier = Bundle.test.bundleIdentifier!
    private(set) lazy var userDefaults = UserDefaults(suiteName: bundleIdentifier)!
}

extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in bundle directory on disk.
    static var test: Bundle {
        return Bundle(for: TempClassForBundle.self)
    }
}
