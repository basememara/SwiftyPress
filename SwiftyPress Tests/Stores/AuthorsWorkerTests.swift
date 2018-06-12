//
//  AuthorsWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

import XCTest
import ZamzamKit
@testable import SwiftyPress

class AuthorsWorkerTests: BaseTestCase, HasDependencies {
    
    private lazy var authorsWorker: AuthorsWorkerType = dependencies.resolveWorker()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

extension AuthorsWorkerTests {
    
    func testFetchByID() {
        let promise = expectation(description: "Authors fetch by ID promise")
        let id = 1
        
        authorsWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Authors fetch by ID error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == id)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByIDError() {
        let promise = expectation(description: "Authors fetch by ID error promise")
        let id = 999
        
        authorsWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard case .nonExistent? = $0.error else {
                return XCTFail("Authors fetch by ID error should have failed.")
            }
            
            XCTAssertTrue(true)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
