//
//  DataWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import Shank
import SwiftyPress

final class DataWorkerTests: BaseTestCase {
    @Inject private var dataWorker: DataWorkerType
    
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


