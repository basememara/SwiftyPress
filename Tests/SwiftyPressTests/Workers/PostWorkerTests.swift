//
//  SwiftyPress_iOSTests.swift
//  SwiftyPress iOSTests
//
//  Created by Basem Emara on 2018-05-30.
//

import XCTest
import SwiftyPress

final class PostWorkerTests: BaseTestCase, HasDependencies {
    private lazy var postWorker: PostWorkerType = dependencies.resolve()
}

extension PostWorkerTests {
    
    func testFetch() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch all promise")
        let request = PostsAPI.FetchRequest()
        
        // When
        postWorker.fetch(with: request) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssertFalse($0.value!.isEmpty, "response should have returned posts")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchCount() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch max length promise")
        let maxLength = 2
        let request = PostsAPI.FetchRequest(maxLength: maxLength)
        
        // When
        postWorker.fetch(with: request) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssertEqual($0.value!.count, maxLength, "response should have returned \(maxLength) post results")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension PostWorkerTests {
    
    func testFetchByID() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by ID promise")
        let id = 5568
        
        // When
        postWorker.fetch(id: id) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.post.id == id, "response should have returned a matching post")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByIDError() {
        // Given
        let promise = expectation(description: "Posts fetch by ID error promise")
        let id = 99999
        
        // When
        postWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            // Then
            guard case .nonExistent? = $0.error else {
                return XCTFail("response should have failed")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension PostWorkerTests {
    
    func testFetchByIDs() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by IDs promise")
        let ids = [791, 26200]
        
        // When
        postWorker.fetch(ids: Set(ids)) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.map { $0.id }.sorted() == ids, "response should have returned matching posts")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension PostWorkerTests {
    
    func testFetchBySlug() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by slug promise")
        let slug = "protocol-oriented-router-in-swift"
        
        // When
        postWorker.fetch(slug: slug) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.slug == slug, "response should have returned matching post slug")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension PostWorkerTests {
    
    func testFetchByURL() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by url promise")
        let url = "http://example.com/swift-delegates-closure-pattern"
        
        // When
        postWorker.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 5568)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL2() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by url 2 promise")
        let url = "http://example.com/whats-new-ios-BEYond/?abc=123#test"
        
        // When
        postWorker.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 791)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL3() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by url 3 promise")
        let url = "/protocol-oriented-THEmes-for-ios-apps/?abc=123#test"
        
        // When
        postWorker.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 41373)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL4() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by url 4 promise")
        let url = "memory-leaKS-resource-management-swift-ios"
        
        // When
        postWorker.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 771)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension PostWorkerTests {
    
    func testFetchByCategories() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by categories promise")
        let ids: Set = [4, 64]
        let request = PostsAPI.FetchRequest()
        
        // When
        postWorker.fetch(byTermIDs: ids, with: request) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy {
                $0.terms.contains(where: ids.contains)
            })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByTags() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by tags promise")
        let ids: Set = [52]
        let request = PostsAPI.FetchRequest()
        
        // When
        postWorker.fetch(byTermIDs: ids, with: request) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy {
                $0.terms.contains(where: ids.contains)
            })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByTerms() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by terms promise")
        let ids: Set = [56, 58, 77]
        let request = PostsAPI.FetchRequest()
        
        // When
        postWorker.fetch(byTermIDs: ids, with: request) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy {
                $0.terms.contains(where: ids.contains)
            })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByTermsCount() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch by terms max length promise")
        let ids: Set = [56, 58, 77]
        let maxLength = 1
        let request = PostsAPI.FetchRequest(maxLength: maxLength)
        
        // When
        postWorker.fetch(byTermIDs: ids, with: request) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy {
                $0.terms.contains(where: ids.contains)
            })
            XCTAssertEqual($0.value!.count, maxLength, "response should have returned \(maxLength) post results")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension PostWorkerTests {
    
    func testFavorites() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Posts fetch favorites promise")
        let ids = [5568, 26200]
        
        // When
        postWorker.addFavorite(id: ids[0])
        postWorker.addFavorite(id: ids[1])
        
        postWorker.fetchFavorites {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.map { $0.id }.sorted() == ids)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
