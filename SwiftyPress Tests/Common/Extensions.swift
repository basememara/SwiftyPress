//
//  Extensions.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    /// Creates a configured expectation with an associated description.
    ///
    ///     asyncExpectation(description: "Fetch profile promise test") { promise in
    ///         // Given
    ///         let request = userID
    ///
    ///         // When
    ///         userWorker.fetchProfile(byUserID: request) {
    ///             defer { promise.fulfill() }
    ///
    ///             guard case .success(let value) = $0 else {
    ///                 return XCTFail("Fetch profile error: \(String(describing: $0.error))")
    ///             }
    ///
    ///             // Then
    ///             XCTAssertGreaterThan(value.id, 0)
    ///             XCTAssertFalse(value.email.isNilOrEmpty)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
    ///   - timeout: The amount of time within which all expectations must be fulfilled.
    ///   - completion: The block to execute with the configured promised injected.
    func asyncExpectation(description: String, timeout: TimeInterval = 10, completion: (XCTestExpectation) -> ()) {
        let promise = expectation(description: description)
        completion(promise)
        waitForExpectations(timeout: timeout, handler: nil)
    }
}

/// Asserts that one value is greater than or equal to zero.
///
/// - Parameters:
///   - expression: An expression of type T, where T is ExpressibleByIntegerLiteral & Comparable.
///   - message: An optional description of the failure.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
func XCTAssertGreaterThanOrEqualToZero<T>(_ expression: T, _ message: String = "", file: StaticString = #file, line: UInt = #line) where T: (ExpressibleByIntegerLiteral & Comparable) {
    XCTAssertGreaterThanOrEqual(expression, 0, message, file: file, line: line)
}

/// Asserts that one value is greater than zero.
///
/// - Parameters:
///   - expression: An expression of type T, where T is ExpressibleByIntegerLiteral & Comparable.
///   - message: An optional description of the failure.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
func XCTAssertGreaterThanZero<T>(_ expression: T, _ message: String = "", file: StaticString = #file, line: UInt = #line) where T: (ExpressibleByIntegerLiteral & Comparable) {
    XCTAssertGreaterThan(expression, 0, message, file: file, line: line)
}
