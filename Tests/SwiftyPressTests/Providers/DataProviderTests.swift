//
//  DataProviderTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

#if !os(watchOS)
import XCTest
import SwiftyPress

final class DataProviderTests: BaseTestCase {
    private lazy var dataProvider: DataProviderType = core.dependency()
    
    func testPull() {
        // Given
        let promise = expectation(description: "Seed fetch all promise")
        
        // When
        dataProvider.pull {
            defer { promise.fulfill() }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
#endif
