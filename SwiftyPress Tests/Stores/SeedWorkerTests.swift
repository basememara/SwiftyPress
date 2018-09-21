//
//  SeedWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
import ZamzamKit
@testable import SwiftyPress

class SeedWorkerTests: BaseTestCase, HasDependencies {
    
    private lazy var seedWorker: SeedWorkerType = dependencies.resolveWorker()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

extension SeedWorkerTests {
    
    func testFetch() {
        let promise = expectation(description: "Seed fetch all promise")
        
        seedWorker.fetch {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Seed fetch all error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(!value.isEmpty)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension SeedWorkerTests {
    
    func testFetchModified() {
        let promise = expectation(description: "Seed fetch modified all promise")
        let modifiedDate = Date(timeIntervalSince1970: 1525910400)
        
        seedWorker.fetchModified(after: modifiedDate) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Seed fetch modified error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.posts.allSatisfy { $0.modifiedAt > modifiedDate})
            XCTAssertTrue(value.authors.allSatisfy { $0.modifiedAt > modifiedDate})
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
