//
//  BaseTestCase.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

#if !os(watchOS)
import XCTest
import ZamzamCore
import SwiftyPress

class BaseTestCase: XCTestCase {
    private lazy var dataProvider: DataProviderType = core.dependency()
    private lazy var preferences: PreferencesType = core.dependency()
    
    lazy var core: SwiftyPressCore = TestsCore()
    
    override func setUp() {
        super.setUp()
        
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
#endif
