//
//  BaseTestCase.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import SwiftyPress

/// Super class for automatically registering dependency configuration container
class BaseTestCase: XCTestCase, CoreInjection {
    
    override func setUp() {
        super.setUp()
        
        // Apple bug: doesn't work when running tests in batches
        // https://bugs.swift.org/browse/SR-906
        continueAfterFailure = false
        
        inject(dependencies: TestConfigurator())
    }
    
    override func tearDown() {
        super.tearDown()
        inject(dependencies: TestConfigurator())
        UserDefaults.test.removeAll()
    }
}
