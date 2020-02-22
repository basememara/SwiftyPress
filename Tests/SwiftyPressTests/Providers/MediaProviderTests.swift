//
//  MediaProviderTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

#if !os(watchOS)
import XCTest
import SwiftyPress

final class MediaProviderTests: BaseTestCase {
    private lazy var mediaProvider: MediaProviderType = core.dependency()
}

extension MediaProviderTests {
    
    func testFetchByID() {
        // Given
        let promise = expectation(description: "Media fetch by ID promise")
        let id = 41397
        
        // When
        mediaProvider.fetch(id: id) {
            defer { promise.fulfill() }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssertTrue($0.value?.id == id)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByIDError() {
        // Given
        let promise = expectation(description: "Media fetch by ID error promise")
        let id = 999999
        
        // When
        mediaProvider.fetch(id: id) {
            defer { promise.fulfill() }
            
            // Then
            guard case .nonExistent? = $0.error else {
                return XCTFail("response should have failed")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
#endif
