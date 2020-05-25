//
//  AuthorsRepositoryTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-03.
//

#if !os(watchOS)
import XCTest
import ZamzamCore
@testable import SwiftyPress

final class AuthorRepositoryTests: TestCase {}

extension AuthorRepositoryTests {
    
    func testFetchFromSuccessfulCacheAndService() {
        // Given
        let promise = expectation(description: #function).apply {
            $0.expectedFulfillmentCount = 2
        }
        
        let repository = AuthorRepository(
            service: AuthorMockService(),
            cache: AuthorMockCache(),
            log: core.log()
        )
        
        var initial: Author?
        var update: Author?
        
        // When
        repository.fetch(with: .init(id: 1)) { result in
            defer { promise.fulfill() }
            
            switch result {
            case .initial(let author):
                initial = author
            case .update(let author):
                update = author
            case .failure:
                XCTFail("Failure should never be executed")
            }
        }
        
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(initial?.id, 1)
        XCTAssertEqual(initial?.name, "John Doe")
        XCTAssertEqual(initial?.avatar, "abc123")
        
        XCTAssertEqual(update?.id, 1)
        XCTAssertEqual(update?.name, "John Doe")
        XCTAssertEqual(update?.avatar, "abc999")
    }
}

extension AuthorRepositoryTests {
    
    func testFetchFromSuccessfulCacheButFailedService() {
        // Given
        let promise = expectation(description: #function)
        
        let repository = AuthorRepository(
            service: AuthorFailedService(),
            cache: AuthorMockCache(),
            log: core.log()
        )
        
        var initial: Author?
        
        // When
        repository.fetch(with: .init(id: 1)) { result in
            defer { promise.fulfill() }
            
            switch result {
            case .initial(let author):
                initial = author
            case .update:
                XCTFail("Update should never be executed")
            case .failure:
                XCTFail("Failure should never be executed")
            }
        }
        
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(initial?.id, 1)
        XCTAssertEqual(initial?.name, "John Doe")
        XCTAssertEqual(initial?.avatar, "abc123")
    }
}

extension AuthorRepositoryTests {
    
    func testFetchFromSuccessfulServiceButFailedCache() {
        // Given
        let promise = expectation(description: #function)
        
        let repository = AuthorRepository(
            service: AuthorMockService(),
            cache: AuthorFailedCache(),
            log: core.log()
        )
        
        var initial: Author?
        
        // When
        repository.fetch(with: .init(id: 1)) { result in
            defer { promise.fulfill() }
            
            switch result {
            case .initial(let author):
                initial = author
            case .update:
                XCTFail("Update should never be executed")
            case .failure:
                XCTFail("Failure should never be executed")
            }
        }
        
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(initial?.id, 1)
        XCTAssertEqual(initial?.name, "John Doe")
        XCTAssertEqual(initial?.avatar, "abc999")
    }
}

extension AuthorRepositoryTests {
    
    func testFetchFromSuccessfulServiceButNoCache() {
        // Given
        let promise = expectation(description: #function)
        
        let repository = AuthorRepository(
            service: AuthorMockService(),
            cache: nil,
            log: core.log()
        )
        
        var initial: Author?
        
        // When
        repository.fetch(with: .init(id: 1)) { result in
            defer { promise.fulfill() }
            
            switch result {
            case .initial(let author):
                initial = author
            case .update:
                XCTFail("Update should never be executed")
            case .failure:
                XCTFail("Failure should never be executed")
            }
        }
        
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(initial?.id, 1)
        XCTAssertEqual(initial?.name, "John Doe")
        XCTAssertEqual(initial?.avatar, "abc999")
    }
}

extension AuthorRepositoryTests {
    
    func testSubscriptionUpdatesAreFiredWithNoCacheExpiry() {
        // Given
        let promise = expectation(description: #function).apply {
            $0.expectedFulfillmentCount = 5
        }
        
        let cache = AuthorMockCache()
        let request = AuthorAPI.FetchRequest(id: 1)
        
        let repository = AuthorRepository(
            service: AuthorMockService(),
            cache: cache,
            log: core.log()
        )
        
        var initial: Author?
        var initialDate: Date?
        var update: Author?
        var updateDate: Date?
        var cancellable: Cancellable?
        
        // When
        repository
            .subscribe(with: request) { result in
                defer { promise.fulfill() }
                
                switch result {
                case .initial(let author):
                    initial = author
                    initialDate = Date()
                case .update(let author):
                    update = author
                    updateDate = Date()
                case .failure:
                    XCTFail("Failure should never be executed")
                }
            }
            .store(in: &cancellable)
        
        repository.fetch(with: request)
        
        // Simulate cache updates minus initial subsrcibe and fetch
        (0...2).forEach { _ in
            repository.fetch(with: request)
        }
        
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(initial?.id, 1)
        XCTAssertEqual(initial?.name, "John Doe")
        XCTAssertEqual(initial?.avatar, "abc123")
        
        XCTAssertEqual(update?.id, 1)
        XCTAssertEqual(update?.name, "John Doe")
        XCTAssertEqual(update?.avatar, "abc999")
        
        XCTAssertNotNil(initialDate)
        XCTAssertNotNil(updateDate)
        XCTAssertGreaterThan(updateDate!, initialDate!, "Subscription update should have fired after initial")
    }
}

extension AuthorRepositoryTests {
    
    func testFetchCacheExpiryThrottlesRequests() {
        // Given
        let promise = expectation(description: #function)
        let cache = AuthorMockCache()
        let request = AuthorAPI.FetchRequest(id: 1)
        
        let repository = AuthorRepository(
            service: AuthorRandomService(),
            cache: cache,
            log: core.log()
        )
        
        var fetchCounter = 0
        var cancellable: Cancellable?
        
        // When
        repository
            .subscribe(with: request) { result in
                switch result {
                case .initial, .update:
                    fetchCounter += 1
                case .failure:
                    XCTFail("Failure should never be executed")
                }
            }
            .store(in: &cancellable)
        
        repository.fetch(with: request, cacheExpiry: 3)
        repository.fetch(with: request, cacheExpiry: 0)
        repository.fetch(with: request, cacheExpiry: 3)
        repository.fetch(with: request, cacheExpiry: 3)
        repository.fetch(with: request, cacheExpiry: 3)
        repository.fetch(with: request, cacheExpiry: 3)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            repository.fetch(with: request, cacheExpiry: 3)
            XCTAssertEqual(fetchCounter, 4)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
}

// MARK: - Mock Types

private extension AuthorRepositoryTests {
    
    struct AuthorMockService: AuthorService {
        
        func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
            completion(.success(AuthorRepositoryTests.author2))
        }
    }
    
    struct AuthorFailedService: AuthorService {
        
        func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
            completion(.failure(.nonExistent))
        }
    }
    
    struct AuthorRandomService: AuthorService {
        
        func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
            completion(.success(AuthorRepositoryTests.authorRandom))
        }
    }
}

private extension AuthorRepositoryTests {
    
    class AuthorMockCache: NSObject, AuthorCache {
        var subscribeBlock: ((ChangeResult<Author, SwiftyPressError>) -> Void)?
        
        func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
            completion(.success(AuthorRepositoryTests.author))
        }
        
        func createOrUpdate(_ request: Author, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
            completion(.success(request))
            subscribeBlock?(.update(request))
        }
        
        func subscribe(
            with request: AuthorAPI.FetchRequest,
            in cancellable: inout Cancellable?,
            change block: @escaping (ChangeResult<Author, SwiftyPressError>) -> Void
        ) {
            self.subscribeBlock = block
            block(.initial(AuthorRepositoryTests.author))
        }
    }
    
    struct AuthorFailedCache: AuthorCache {
        
        func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
            completion(.failure(.nonExistent))
        }
        
        func createOrUpdate(_ request: Author, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
            completion(.success(request))
        }
        
        func subscribe(
            with request: AuthorAPI.FetchRequest,
            in cancellable: inout Cancellable?,
            change block: @escaping (ChangeResult<Author, SwiftyPressError>) -> Void
        ) {
            block(.failure(.nonExistent))
        }
    }
}

// MARK: - Mock Data

private extension AuthorRepositoryTests {
    
    static let author = Author(
        id: 1,
        name: "John Doe",
        link: "https://example.com/123",
        avatar: "abc123",
        content: "Some content",
        createdAt: Date(),
        modifiedAt: Date()
    )
    
    static let author2 = Author(
        id: 1,
        name: "John Doe",
        link: "https://example.com/123",
        avatar: "abc999",
        content: "Some content",
        createdAt: Date(),
        modifiedAt: Date()
    )
    
    static var authorRandom: Author {
        Author(
            id: 1,
            name: "John Doe",
            link: "https://example.com/123",
            avatar: UUID().uuidString,
            content: "Some content",
            createdAt: Date(),
            modifiedAt: Date()
        )
    }
}
#endif
