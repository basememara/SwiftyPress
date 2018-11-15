//
//  MediaWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

import XCTest
import ZamzamKit
@testable import SwiftyPress

class MediaWorkerTests: BaseTestCase, HasDependencies {
    
    private lazy var mediaWorker: MediaWorkerType = dependencies.resolveWorker()
    
}

extension MediaWorkerTests {
    
    func testFetchByID() {
        let promise = expectation(description: "Media fetch by ID promise")
        let id = 41287
        
        mediaWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Media fetch by ID error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == id)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByIDError() {
        let promise = expectation(description: "Media fetch by ID error promise")
        let id = 999999
        
        mediaWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard case .nonExistent? = $0.error else {
                return XCTFail("Media fetch by ID error should have failed.")
            }
            
            XCTAssertTrue(true)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
