//
//  SwiftyPress_iOSTests.swift
//  SwiftyPress iOSTests
//
//  Created by Basem Emara on 2018-05-30.
//

import XCTest
import ZamzamKit
@testable import SwiftyPress

class PostsWorkerTests: BaseTestCase, HasDependencies {
    
    private lazy var postsWorker: PostsWorkerType = dependencies.resolveWorker()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

extension PostsWorkerTests {
    
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
            
            let expression = value.allSatisfy {
                $0.categories.contains(where: ids.contains)
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
            
            let expression = value.allSatisfy {
                $0.tags.contains(where: ids.contains)
            }
            
            XCTAssertTrue(expression)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
