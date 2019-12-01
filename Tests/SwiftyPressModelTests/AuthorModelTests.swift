//
//  AuthorModelTests.swift
//  SwiftyPress ModelTests
//
//  Created by Basem Emara on 2019-05-17.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import SwiftyPress
import ZamzamCore

final class AuthorModelTests: XCTestCase {
    
}

extension AuthorModelTests {
    
    func testDecoding() {
        do {
            let model = try JSONDecoder.default.decode(
                Author.self,
                forResource: "Author.json",
                inBundle: .test
            )
            
            XCTAssertEqual(model.id, 2)
            XCTAssertEqual(model.name, "Basem Emara")
            XCTAssertEqual(model.link, "https://staging1.basememara.com")
            XCTAssertEqual(model.avatar, "https://secure.gravatar.com/avatar/8def0d36f56d3e6720a44e41bf6f9a71?s=96&d=mm&r=g")
            XCTAssertEqual(model.content, "Basem is a mobile and software IT professional with over 12 years of experience as an architect, developer, and consultant for dozens of projects that span over various industries for Fortune 500 enterprises, government agencies, and startups. In 2014, Basem brought his vast knowledge and experiences to Swift and helped pioneer the language to build scalable enterprise iOS &amp; watchOS apps, later providing mentorship courses at <a href=\"https://iosmentor.io\">https://iosmentor.io</a>.")
            XCTAssertEqual(model.createdAt, DateFormatter.iso8601.date(from: "2015-02-02T03:39:52"))
            XCTAssertEqual(model.modifiedAt, DateFormatter.iso8601.date(from: "2018-10-06T14:43:53"))
        } catch {
            XCTFail("Could not parse JSON: \(error)")
        }
    }
}
