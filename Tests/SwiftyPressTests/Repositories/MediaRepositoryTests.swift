//
//  MediaRepositoryTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

#if !os(watchOS)
import XCTest
import SwiftyPress

final class MediaRepositoryTests: TestCase {
    private lazy var mediaRepository = core.mediaRepository()
}

extension MediaRepositoryTests {
    
    func testFetchByID() {
        // Given
        let promise = expectation(description: #function)
        let id = 41397
        
        // When
        mediaRepository.fetch(id: id) {
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
        let promise = expectation(description: #function)
        let id = 999999
        
        // When
        mediaRepository.fetch(id: id) {
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
