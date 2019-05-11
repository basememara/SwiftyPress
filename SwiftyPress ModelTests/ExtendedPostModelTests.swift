//
//  PayloadModelTests.swift
//  SwiftyPress ModelTests
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
@testable import SwiftyPress

class ExtendedPostModelTests: XCTestCase {
    
    func testDecoding() {
        do {
            let model = try JSONDecoder.default.decode(
                ExtendedPost.self,
                forResource: "ExtendedPost.json",
                inBundle: .test
            )
            
            //XCTAssertEqual(model.id, 41294)
        } catch {
            XCTFail("Could not parse JSON: \(error)")
        }
    }
}
