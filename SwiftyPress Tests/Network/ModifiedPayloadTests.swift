//
//  PayloadNetwork.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//

import XCTest
import ZamzamKit
import SwiftyPress

class ModifiedPayloadTests: BaseTestCase, HasDependencies {
    private lazy var seedWorker: SeedWorkerType = dependencies.resolveWorker()
    
}

extension ModifiedPayloadTests {
    
    func testFetchAll() {
        let promise = expectation(description: "Seed modified fetch all promise")
        
        seedWorker.fetch {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("testRequest Error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(!value.isEmpty)
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
}

extension ModifiedPayloadTests {
    
    func testFetchNoModified() {
        let promise = expectation(description: "Seed modified fetch no modified promise")
        
        seedWorker.fetchModified(after: Date()) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("testRequest Error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.isEmpty)
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
}
