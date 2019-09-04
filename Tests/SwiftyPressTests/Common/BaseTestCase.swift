//
//  BaseTestCase.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest

class BaseTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Apple bug: doesn't work when running tests in batches
        // https://bugs.swift.org/browse/SR-906
        continueAfterFailure = false
        
        UserDefaults.test.removeAll()
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.test.removeAll()
    }
}
