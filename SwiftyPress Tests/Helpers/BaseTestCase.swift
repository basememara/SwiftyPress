//
//  BaseTestCase.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import SwiftyPress

class BaseTestCase: XCTestCase, DependencyConfigurator {
    
    var resolveContainer: DependencyFactoryType {
        return TestDependency()
    }
    
    override func setUp() {
        super.setUp()
        register(dependencies: resolveContainer)
        TestUtils.shared.defaults.removeAll()
    }
}
