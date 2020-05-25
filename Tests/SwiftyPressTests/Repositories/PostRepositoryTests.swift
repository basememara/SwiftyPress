//
//  SwiftyPress_iOSTests.swift
//  SwiftyPress iOSTests
//
//  Created by Basem Emara on 2018-05-30.
//

#if !os(watchOS)
import XCTest
import SwiftyPress

final class PostRepositoryTests: TestCase {
    private lazy var postRepository = core.postRepository()
}

extension PostRepositoryTests {
    
    func testFetch() {
        // Given
        var promise: XCTestExpectation? = expectation(description: #function)
        let request = PostAPI.FetchRequest()
        
        // When
        postRepository.fetch(with: request) {
            // Handle double calls used for remote fetching
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
        var promise: XCTestExpectation? = expectation(description: #function)
        let maxLength = 2
        let request = PostAPI.FetchRequest(maxLength: maxLength)
        
        // When
        postRepository.fetch(with: request) {
            // Handle double calls used for remote fetching
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

extension PostRepositoryTests {
    
    func testFetchByID() {
        // Given
        var promise: XCTestExpectation? = expectation(description: #function)
        let id = 5568
        
        // When
        postRepository.fetch(id: id) {
            // Handle double calls used for remote fetching
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
        let promise = expectation(description: #function)
        let id = 99999
        
        // When
        postRepository.fetch(id: id) {
            defer { promise.fulfill() }
            
            // Then
            guard case .nonExistent? = $0.error else {
                return XCTFail("response should have failed")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension PostRepositoryTests {
    
    func testFetchByIDs() {
        // Given
        var promise: XCTestExpectation? = expectation(description: #function)
        let ids = [791, 26200]
        
        // When
        postRepository.fetch(ids: Set(ids)) {
            // Handle double calls used for remote fetching
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

extension PostRepositoryTests {
    
    func testFetchBySlug() {
        // Given
        var promise: XCTestExpectation? = expectation(description: #function)
        let slug = "protocol-oriented-router-in-swift"
        
        // When
        postRepository.fetch(slug: slug) {
            // Handle double calls used for remote fetching
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

extension PostRepositoryTests {
    
    func testFetchByURL() {
        // Given
        var promise: XCTestExpectation? = expectation(description: #function)
        let url = "http://example.com/swift-delegates-closure-pattern"
        
        // When
        postRepository.fetch(url: url) {
            // Handle double calls used for remote fetching
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
        var promise: XCTestExpectation? = expectation(description: #function)
        let url = "http://example.com/whats-new-ios-BEYond/?abc=123#test"
        
        // When
        postRepository.fetch(url: url) {
            // Handle double calls used for remote fetching
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
        var promise: XCTestExpectation? = expectation(description: #function)
        let url = "/protocol-oriented-THEmes-for-ios-apps/?abc=123#test"
        
        // When
        postRepository.fetch(url: url) {
            // Handle double calls used for remote fetching
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
        var promise: XCTestExpectation? = expectation(description: #function)
        let url = "memory-leaKS-resource-management-swift-ios"
        
        // When
        postRepository.fetch(url: url) {
            // Handle double calls used for remote fetching
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

extension PostRepositoryTests {
    
    func testFetchByCategories() {
        // Given
        var promise: XCTestExpectation? = expectation(description: #function)
        let ids: Set = [4, 64]
        let request = PostAPI.FetchRequest()
        
        // When
        postRepository.fetch(byTermIDs: ids, with: request) {
            // Handle double calls used for remote fetching
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
        var promise: XCTestExpectation? = expectation(description: #function)
        let ids: Set = [52]
        let request = PostAPI.FetchRequest()
        
        // When
        postRepository.fetch(byTermIDs: ids, with: request) {
            // Handle double calls used for remote fetching
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
        var promise: XCTestExpectation? = expectation(description: #function)
        let ids: Set = [56, 58, 77]
        let request = PostAPI.FetchRequest()
        
        // When
        postRepository.fetch(byTermIDs: ids, with: request) {
            // Handle double calls used for remote fetching
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
        var promise: XCTestExpectation? = expectation(description: #function)
        let ids: Set = [56, 58, 77]
        let maxLength = 1
        let request = PostAPI.FetchRequest(maxLength: maxLength)
        
        // When
        postRepository.fetch(byTermIDs: ids, with: request) {
            // Handle double calls used for remote fetching
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
#endif
