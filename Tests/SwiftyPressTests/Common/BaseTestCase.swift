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
    
    private let container = Dependencies {
        Module { TestsModule() as SwiftyPressModule }
    }
    
    @Inject var module: SwiftyPressModule
    
    private lazy var dataProvider: DataProviderType = module.component()
    private lazy var preferences: PreferencesType = module.component()
    
    override func setUp() {
        super.setUp()
        
        container.build()
        
        // Apple bug: doesn't work when running tests in batches
        // https://bugs.swift.org/browse/SR-906
        continueAfterFailure = false
        
        // Clear previous
        dataProvider.resetCache(for: preferences.userID ?? 0)
        preferences.removeAll()
        UserDefaults.test.removeAll()
        
        // Setup database
        dataProvider.configure()
    }
}
