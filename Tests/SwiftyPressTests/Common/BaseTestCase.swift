//
//  BaseTestCase.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import SwiftyPress
import ZamzamCore

class BaseTestCase: XCTestCase {
    private static let container = Container() // Dependency injection
    
    @Inject private var dataWorker: DataWorkerType
    @Inject private var preferences: PreferencesType
    
    override class func setUp() {
        super.setUp()
        
        container.import {
            CoreModule.self
            TestModule.self
        }
    }
    
    override func setUp() {
        super.setUp()
        
        // Apple bug: doesn't work when running tests in batches
        // https://bugs.swift.org/browse/SR-906
        continueAfterFailure = false
        
        // Clear previous
        dataWorker.resetCache(for: preferences.userID ?? 0)
        preferences.removeAll()
        UserDefaults.test.removeAll()
        
        // Setup database
        dataWorker.configure()
    }
}
