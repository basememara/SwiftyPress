//
//  BaseTestCase.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import SwiftyPress

class BaseTestCase: XCTestCase, DependencyConfigurator {
    
    override func setUp() {
        super.setUp()
        configure(with: TestDependency())
    }
    
    override func tearDown() {
        super.tearDown()
        configure(with: TestDependency())
    }
}
