//
//  SwiftyPress_ModelTests.swift
//  SwiftyPress ModelTests
//
//  Created by Basem Emara on 2019-05-11.
//

#if !os(watchOS)
import XCTest
import ZamzamCore

extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in bundle directory on disk.
    static let test = Bundle(for: TempClassForBundle.self)
}

extension DateFormatter {
    static let iso8601 = DateFormatter(iso8601Format: "yyyy-MM-dd'T'HH:mm:ss")
}

extension JSONDecoder {
    
    /// Decodes the given type from the given JSON representation of the current file.
    func decode<T>(_ type: T.Type, fromJSON file: String, suffix: String? = nil) throws -> T where T : Decodable {
        let path = URL(fileURLWithPath: file)
            .replacingPathExtension("json")
            .appendingToFileName(suffix ?? "")
            .path
        
        guard let data = FileManager.default.contents(atPath: path) else {
            throw NSError(domain: "SwiftyPressModelTests.JSONDecoder", code: NSFileReadUnknownError)
        }
        
        return try decode(type, from: data)
    }
}

extension XCTestCase {
    
    /// Asserts that all values are equal.
    ///
    /// - Parameters:
    ///   - values: A list of values of type T, where T is Equatable.
    ///   - message: An optional description of the failure.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
    func XCTAssertAllEqual<T: Equatable>(_ values: T?..., message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        _ = values.reduce(values.first) { current, next in
            XCTAssertEqual(current, next, message(), file: file, line: line)
            return next
        }
    }
    
    /// Asserts that two values are equal and not nil.
    ///
    /// - Parameters:
    ///   - expression1: An expression of type T, where T is Equatable.
    ///   - values: An expression of type T, where T is Equatable.
    ///   - expression2: An optional description of the failure.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
    func XCTAssertEqualAndNotNil<T: Equatable>(_ expression1: @autoclosure () -> T?, _ expression2: @autoclosure () -> T?, message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(expression1(), message(), file: file, line: line)
        XCTAssertNotNil(expression2(), message(), file: file, line: line)
        XCTAssertEqual(expression1(), expression2(), message(), file: file, line: line)
    }
}

// MARK: - Utility Testing

final class UtilitiesTests: XCTestCase {
    
    func testAssertAllEqual() throws {
        XCTAssertAllEqual(1, 1, 1, 1, 1, 1, 1)
        XCTAssertAllEqual("a", "a", "a", "a", "a")
        
        // Tested below but must exclude from live test runs
        // XCTAssertAllEqual(1, 1, 1, 2, 1, 1, 1)
    }
    
    func testAssertEqualAndNotNil() throws {
        XCTAssertEqualAndNotNil(1, 1)
        
        // Tested below but must exclude from live test runs
        // let value: String? = nil
        // XCTAssertEqualAndNotNil(value, value)
    }
}
#endif
