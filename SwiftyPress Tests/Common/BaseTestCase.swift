//
//  BaseTestCase.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import SwiftyPress

/// Super class for automatically registering dependency configuration container
class BaseTestCase: XCTestCase, CoreInjection, HasDependencies {
    private lazy var dataWorker: DataWorkerType = dependencies.resolve()
    
    override class func setUp() {
        super.setUp()
        
        inject(dependencies: TestConfigurator())
        UserDefaults.test.removeAll()
    }
    
    override func setUp() {
        super.setUp()
        
        // Apple bug: doesn't work when running tests in batches
        // https://bugs.swift.org/browse/SR-906
        continueAfterFailure = false
        
        dataWorker.configure()
    }
    
    override class func tearDown() {
        super.tearDown()
        UserDefaults.test.removeAll()
    }
}
