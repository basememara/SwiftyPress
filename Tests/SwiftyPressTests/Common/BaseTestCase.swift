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
    private lazy var dataRepository: DataRepositoryType = core.dataRepository()
    private lazy var preferences: PreferencesType = core.preferences()
    
    lazy var core: SwiftyPressCore = TestsCore()
    
    override func setUp() {
        super.setUp()
        
        // Apple bug: doesn't work when running tests in batches
        // https://bugs.swift.org/browse/SR-906
        continueAfterFailure = false
        
        // Clear previous
        dataRepository.resetCache(for: preferences.userID ?? 0)
        preferences.removeAll()
        
        // Setup database
        dataRepository.configure()
    }
}
#endif
