//
//  DataWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import SwiftyPress

class DataWorkerTests: BaseTestCase, HasDependencies {
    private lazy var dataWorker: DataWorkerType = dependencies.resolve()
    
    func testPull() {
        // Given
        let promise = expectation(description: "Seed fetch all promise")
        
        // When
        dataWorker.pull {
            defer { promise.fulfill() }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

