//
//  TestUtils.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//

import Foundation

class TestUtils {
    static let shared: TestUtils = TestUtils()
    
    lazy var bundle = Bundle(for: type(of: self))
    lazy var bundleIdentifier = bundle.bundleIdentifier!
    
    lazy var defaults: UserDefaults = UserDefaults(
        suiteName: bundleIdentifier
    )!
}
