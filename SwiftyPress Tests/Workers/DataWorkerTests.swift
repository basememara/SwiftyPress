//
//  DataWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import XCTest
@testable import SwiftyPress

class DataWorkerTests: BaseTestCase, HasDependencies {
    private lazy var dataWorker: DataWorkerType = dependencies.resolve()
    private lazy var syncStore: SyncStore = dependencies.resolveStore()
}

extension DataWorkerTests {
    
    func testFetch() {
        let promise = expectation(description: "Seed fetch all promise")
        
        dataWorker.sync {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Seed fetch all error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(!value.isEmpty)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension DataWorkerTests {
    
    func testFetchModified() {
        let promise = expectation(description: "Seed fetch modified all promise")
        let modifiedDate = Date(timeIntervalSince1970: 1525910400)
        
        syncStore.fetchModified(after: modifiedDate) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Seed fetch modified error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.posts.allSatisfy { $0.modifiedAt > modifiedDate})
            XCTAssertTrue(value.authors.allSatisfy { $0.modifiedAt > modifiedDate})
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension DataWorkerTests {
    
    func testFetchNoModified() {
        let promise = expectation(description: "Seed fetch no modified promise")
        
        syncStore.fetchModified(after: Date()) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Seed fetch no modified error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.isEmpty)
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
}

