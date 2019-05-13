//
//  AuthorsWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

import XCTest
import SwiftyPress

class AuthorWorkerTests: BaseTestCase {
    private lazy var authorWorker: AuthorWorkerType = dependencies.resolve()
}

extension AuthorWorkerTests {
    
    func testFetchByID() {
        let promise = expectation(description: "Authors fetch by ID promise")
        let id = 2
        
        authorWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Authors fetch by ID error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == id)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByIDError() {
        let promise = expectation(description: "Authors fetch by ID error promise")
        let id = 999
        
        authorWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard case .nonExistent? = $0.error else {
                return XCTFail("Authors fetch by ID error should have failed.")
            }
            
            XCTAssertTrue(true)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
