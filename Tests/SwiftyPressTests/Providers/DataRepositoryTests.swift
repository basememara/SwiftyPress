//
//  DataRepositoryTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

#if !os(watchOS)
import XCTest
import SwiftyPress

final class DataRepositoryTests: BaseTestCase {
    private lazy var dataRepository: DataRepositoryType = core.dataRepository()
    
    func testPull() {
        // Given
        let promise = expectation(description: #function)
        
        // When
        dataRepository.pull {
            defer { promise.fulfill() }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
#endif
