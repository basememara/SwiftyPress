//
//  MediaModelTests.swift
//  SwiftyPress ModelTests
//
//  Created by Basem Emara on 2019-05-17.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
@testable import SwiftyPress

class MediaModelTests: XCTestCase {
    
    func testDecoding() {
        do {
            let model = try JSONDecoder.default.decode(
                Media.self,
                forResource: "Media.json",
                inBundle: .test
            )
            
            XCTAssertEqual(model.id, 41382)
            XCTAssertEqual(model.link, "https://basememara.com/wp-content/uploads/2018/09/UIKit-Xcode-Custom-Class.png")
            XCTAssertEqual(model.width, 854)
            XCTAssertEqual(model.height, 480)
            XCTAssertEqual(model.thumbnailLink, "https://basememara.com/wp-content/uploads/2018/09/UIKit-Xcode-Custom-Class-500x281.png")
            XCTAssertEqual(model.thumbnailWidth, 500)
            XCTAssertEqual(model.thumbnailHeight, 281)
        } catch {
            XCTFail("Could not parse JSON: \(error)")
        }
    }
}
