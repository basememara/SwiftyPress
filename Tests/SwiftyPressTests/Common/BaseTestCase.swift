//
//  BaseTestCase.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import ZamzamCore
import SwiftyPress

class BaseTestCase: XCTestCase {
    
    private static let container = Dependencies {
        Module { TestsModule() as SwiftyPressModule }
    }
    
    @Inject var module: SwiftyPressModule
    
    private lazy var dataWorker: DataWorkerType = module.component()
    private lazy var preferences: PreferencesType = module.component()
    
    override class func setUp() {
        super.setUp()
        container.build()
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
