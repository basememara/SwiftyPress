//
//  SwiftyPress_iOSTests.swift
//  SwiftyPress iOSTests
//
//  Created by Basem Emara on 3/27/16.
//
//

import XCTest
@testable import SwiftyPress

class SwiftyPress_iOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPosts() {
        let postService = PostService()
        
        postService.get()
        
        XCTAssert(true)
    }
    
}
