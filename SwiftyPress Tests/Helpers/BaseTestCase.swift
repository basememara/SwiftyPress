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
        register(dependencies: TestDependency())
    }
    
    override func tearDown() {
        super.tearDown()
        register(dependencies: TestDependency())
    }
}
