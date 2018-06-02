//
//  SwiftyPress_iOSTests.swift
//  SwiftyPress iOSTests
//
//  Created by Basem Emara on 2018-05-30.
//

import XCTest
import ZamzamKit
@testable import SwiftyPress

class PostsWorkerTests: XCTestCase {
    
    private let postsWorker: PostsWorkerType = PostsWorker()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetch() {
        let promise = expectation(description: "Posts fetch all promise")
        
        postsWorker.fetch {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Posts fetch all error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(!value.isEmpty)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension PostsWorkerTests {
    
    func testFetchByID() {
        let promise = expectation(description: "Posts fetch by ID promise")
        let id = 1
        
        postsWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Posts fetch by ID error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == id)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByIDError() {
        let promise = expectation(description: "Posts fetch by ID error promise")
        let id = 999
        
        postsWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard case .nonExistent? = $0.error else {
                return XCTFail("Posts fetch by ID error should have failed.")
            }
            
            XCTAssertTrue(true)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension PostsWorkerTests {
    
    func testFetchByCategories() {
        let promise = expectation(description: "Posts fetch by categories promise")
        let ids: Set = [1, 9]
        
        postsWorker.fetch(byCategoryIDs: ids) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Posts fetch by categories error: \(String(describing: $0.error))")
            }
            
            let expression = value.reduce(true) { result, next in
                result && next.categories.contains(where: ids.contains)
            }
            
            XCTAssertTrue(expression)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByTags() {
        let promise = expectation(description: "Posts fetch by tags promise")
        let ids: Set = [11]
        
        postsWorker.fetch(byTagIDs: ids) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Posts fetch by tags error: \(String(describing: $0.error))")
            }
            
            let expression = value.reduce(true) { result, next in
                result && next.tags.contains(where: ids.contains)
            }
            
            XCTAssertTrue(expression)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

struct PostsWorker: PostsWorkerType {
    
}

extension PostsWorker {
    
    func fetch(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        completion(.success([
            Post(
                id: 1,
                slug: "test-post-1",
                type: "post",
                title: "Test post 1",
                content: "This is a test description 1.",
                excerpt: "This is a test excerpt 1.",
                link: "http://example.com/test-post-1",
                commentCount: 101,
                authorID: 1,
                mediaID: 1,
                categories: [1, 2, 3],
                tags: [10, 20, 30],
                createdAt: Date(),
                modifiedAt: Date()
            ),
            Post(
                id: 2,
                slug: "test-post-2",
                type: "post",
                title: "Test post 2",
                content: "This is a test description 2.",
                excerpt: "This is a test excerpt 2.",
                link: "http://example.com/test-post-2",
                commentCount: 102,
                authorID: 1,
                mediaID: 2,
                categories: [3, 4, 5, 6],
                tags: [10, 11, 21, 31],
                createdAt: Date(),
                modifiedAt: Date()
            ),
            Post(
                id: 3,
                slug: "test-post-3",
                type: "post",
                title: "Test post 3",
                content: "This is a test description 3.",
                excerpt: "This is a test excerpt 3.",
                link: "http://example.com/test-post-3",
                commentCount: 103,
                authorID: 1,
                mediaID: 3,
                categories: [6, 7, 8, 9],
                tags: [11, 12, 22, 32],
                createdAt: Date(),
                modifiedAt: Date()
            )
        ]))
    }
    
    func fetch(id: Int, completion: @escaping (Result<PostType, DataError>) -> Void) {
        fetch {
            guard let value = $0.value?.first(where: { $0.id == id }), $0.isSuccess else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
}

extension PostsWorker {
    
    func fetch(byCategoryIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let results = value.filter {
                $0.categories.contains(where: ids.contains)
            }
            
            completion(.success(results))
        }
    }
    
    func fetch(byTagIDs ids: Set<Int>, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            let results = value.filter {
                $0.tags.contains(where: ids.contains)
            }
            
            completion(.success(results))
        }
    }
}

extension PostsWorker {
    
    func fetchPopular(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
    
    func fetchFavorites(completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping (Result<[PostType], DataError>) -> Void) {
        fatalError("Not implemented")
    }
}
