//
//  SwiftyPress_iOSTests.swift
//  SwiftyPress iOSTests
//
//  Created by Basem Emara on 2018-05-30.
//

import XCTest
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
            XCTAssertTrue(!$0.isEmpty)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByID() {
        let promise = expectation(description: "Posts fetch by ID promise")
        let id = 1
        
        postsWorker.fetch(id: id) {
            XCTAssertTrue($0.id == id)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

struct PostsWorker: PostsWorkerType {
    
}

extension PostsWorker {
    
    func fetch(completion: @escaping ([PostType]) -> Void) {
        completion([
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
        ])
    }
    
    func fetch(id: Int, completion: @escaping (PostType) -> Void) {
        fetch {
            // TODO: Get rid of optional
            completion($0.first { $0.id == id }!)
        }
    }
}

extension PostsWorker {
    
    func fetch(byCategoryIDs: [Int], completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
    
    func fetch(byTagIDs: [Int], completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
}

extension PostsWorker {
    
    func fetchPopular(completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
    
    func fetchFavorites(completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
}

extension PostsWorker {
    
    func search(with request: PostsModels.SearchRequest, completion: @escaping ([PostType]) -> Void) {
        fatalError("Not implemented")
    }
}
