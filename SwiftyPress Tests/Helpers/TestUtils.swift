//
//  TestUtils.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//

import Foundation

class TestUtils {
    static let shared: TestUtils = TestUtils()
    
    lazy var bundle: Bundle = {
        Bundle(for: type(of: self))
    }()
    
    lazy var bundleIdentifier: String = {
        bundle.bundleIdentifier!
    }()
}
