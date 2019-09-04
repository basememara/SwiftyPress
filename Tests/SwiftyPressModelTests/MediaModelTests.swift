//
//  MediaModelTests.swift
//  SwiftyPress ModelTests
//
//  Created by Basem Emara on 2019-05-17.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
@testable import SwiftyPress

final class MediaModelTests: XCTestCase {

}

extension MediaModelTests {
    
    func testDecoding() {
        do {
            let model = try JSONDecoder.default.decode(
                Media.self,
                forResource: "Media.json",
                inBundle: .test
            )
            
            XCTAssertEqual(model.id, 41346)
            XCTAssertEqual(model.link, "https://staging1.basememara.com/wp-content/uploads/2018/04/Clean-Architecture-Cycle-2.png")
            XCTAssertEqual(model.width, 500)
            XCTAssertEqual(model.height, 518)
            XCTAssertEqual(model.thumbnailLink, "https://staging1.basememara.com/wp-content/uploads/2018/04/Clean-Architecture-Cycle-2-500x518.png")
            XCTAssertEqual(model.thumbnailWidth, 500)
            XCTAssertEqual(model.thumbnailHeight, 518)
        } catch {
            XCTFail("Could not parse JSON: \(error)")
        }
    }
}
