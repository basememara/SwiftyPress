//
//  TaxonomyWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-02.
//

import XCTest
import SwiftyPress

class TaxonomyWorkerTests: BaseTestCase {
    private lazy var taxonomyWorker: TaxonomyWorkerType = dependencies.resolve()
}

extension TaxonomyWorkerTests {
    
    func testFetch() {
        let promise = expectation(description: "Terms fetch all promise")
        
        taxonomyWorker.fetch {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch all error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(!value.isEmpty)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByID() {
        let promise = expectation(description: "Terms fetch by ID promise")
        let id = 55
        
        taxonomyWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by ID error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == id)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByIDs() {
        let promise = expectation(description: "Terms fetch by IDs promise")
        let ids: Set = [4, 55, 64]
        
        taxonomyWorker.fetch(ids: ids) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by IDs error: \(String(describing: $0.error))")
            }
            
            let expression = value.map { $0.id }.sorted() == Array(ids).sorted()
            
            XCTAssertTrue(expression)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchBySlug() {
        let promise = expectation(description: "Terms fetch by slug promise")
        let slug = "swift"
        
        taxonomyWorker.fetch(slug: slug) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by slug error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.slug == slug)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByURL() {
        let promise = expectation(description: "Terms fetch by url promise")
        let url = "https://example.com/category/swift"
        
        taxonomyWorker.fetch(url: url) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by url error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == 55)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL2() {
        let promise = expectation(description: "Terms fetch by url 2 promise")
        let url = "https://example.com/category/swift/?abc=123#test"
        
        taxonomyWorker.fetch(url: url) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by url 2 error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == 55)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL3() {
        let promise = expectation(description: "Terms fetch by url 3 promise")
        let url = "/tag/protocol-oriented-PROgramming/?abc=123#test"
        
        taxonomyWorker.fetch(url: url) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by url 3 error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == 62)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL4() {
        let promise = expectation(description: "Terms fetch by url 4 promise")
        let url = "taG/deleGAtes"
        
        taxonomyWorker.fetch(url: url) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by url 4 error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == 74)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByCategory() {
        let promise = expectation(description: "Terms fetch by category error promise")
        
        taxonomyWorker.fetch(by: .category) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by category error should have failed.")
            }
            
            XCTAssertTrue(value.allSatisfy { $0.taxonomy == .category })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByTag() {
        let promise = expectation(description: "Terms fetch by tag error promise")
        
        taxonomyWorker.fetch(by: .tag) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                return XCTFail("Terms fetch by tag error should have failed.")
            }
            
            XCTAssertTrue(value.allSatisfy { $0.taxonomy == .tag })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
