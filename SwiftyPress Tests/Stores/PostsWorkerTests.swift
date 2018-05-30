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
    
    func testExample() {
        let promise = expectation(description: "Posts fetch all promise")
        
        postsWorker.fetch {
            XCTAssertTrue(!$0.isEmpty)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

struct PostsWorker: PostsWorkerType {
    
}

extension PostsWorker {
    
    func fetch(completion: @escaping ([PostType]) -> Void) {
        completion([])
    }
    
    func fetch(id: Int, completion: @escaping (PostType) -> Void) {
        fatalError("Not implemented")
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
