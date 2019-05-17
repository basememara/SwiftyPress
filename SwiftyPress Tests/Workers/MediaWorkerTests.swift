//
//  MediaWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

import XCTest
import SwiftyPress

class MediaWorkerTests: BaseTestCase, HasDependencies {
    private lazy var mediaWorker: MediaWorkerType = dependencies.resolve()
}

extension MediaWorkerTests {
    
    func testFetchByID() {
        // Given
        let promise = expectation(description: "Media fetch by ID promise")
        let id = 41397
        
        // When
        mediaWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssertTrue($0.value?.id == id)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByIDError() {
        // Given
        let promise = expectation(description: "Media fetch by ID error promise")
        let id = 999999
        
        // When
        mediaWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            // Then
            guard case .nonExistent? = $0.error else {
                return XCTFail("response should have failed")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
