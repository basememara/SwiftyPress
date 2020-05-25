//
//  FavoriteRepositoryTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2020-05-25.
//

#if !os(watchOS)
import XCTest
import SwiftyPress

final class FavoriteRepositoryTests: TestCase {
    private lazy var favoriteRepository = core.favoriteRepository()
}

extension FavoriteRepositoryTests {
    
    func testFavorites() {
        // Given
        var promise: XCTestExpectation? = expectation(description: #function)
        let ids = [5568, 26200]
        
        // When
        favoriteRepository.addFavorite(id: ids[0])
        favoriteRepository.addFavorite(id: ids[1])
        
        favoriteRepository.fetch {
            // Handle double calls used for remote fetching
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
#endif
