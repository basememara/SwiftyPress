//
//  TaxonomyWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-02.
//

import XCTest
import SwiftyPress

class TaxonomyWorkerTests: BaseTestCase, HasDependencies {
    private lazy var taxonomyWorker: TaxonomyWorkerType = dependencies.resolve()
}

extension TaxonomyWorkerTests {
    
    func testFetch() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch all promise")
        
        // When
        taxonomyWorker.fetch {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert(!$0.value!.isEmpty)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByID() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by ID promise")
        let id = 55
        
        // When
        taxonomyWorker.fetch(id: id) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == id)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByIDs() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by IDs promise")
        let ids: Set = [4, 55, 64]
        
        // When
        taxonomyWorker.fetch(ids: ids) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssertEqual($0.value?.map { $0.id }.sorted(), Array(ids).sorted())
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchBySlug() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by slug promise")
        let slug = "swift"
        
        // When
        taxonomyWorker.fetch(slug: slug) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.slug == slug)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByURL() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by url promise")
        let url = "https://example.com/category/swift"
        
        // When
        taxonomyWorker.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 55)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL2() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by url 2 promise")
        let url = "https://example.com/category/swift/?abc=123#test"
        
        // When
        taxonomyWorker.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 55)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL3() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by url 3 promise")
        let url = "/tag/protocol-oriented-PROgramming/?abc=123#test"
        
        // When
        taxonomyWorker.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 62)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL4() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by url 4 promise")
        let url = "taG/deleGAtes"
        
        // When
        taxonomyWorker.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 74)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByCategory() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by category error promise")
        
        // When
        taxonomyWorker.fetch(by: .category) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy { $0.taxonomy == .category })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByTag() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by tag error promise")
        
        // When
        taxonomyWorker.fetch(by: .tag) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy { $0.taxonomy == .tag })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
