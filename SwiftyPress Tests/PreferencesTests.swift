//
//  PreferencesWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//

import XCTest
import ZamzamKit
import SwiftyPress

class PreferencesTests: BaseTestCase, HasDependencies {
    
    private lazy var preferences: PreferencesType = dependencies.resolve()
    
}

extension PreferencesTests {
    
    func testUserDefaults() {
        preferences.set("abc", forKey: .testString1)
        preferences.set("xyz", forKey: .testString2)
        preferences.set(true, forKey: .testBool1)
        preferences.set(false, forKey: .testBool2)
        preferences.set(123, forKey: .testInt1)
        preferences.set(987, forKey: .testInt2)
        preferences.set(1.1, forKey: .testFloat1)
        preferences.set(9.9, forKey: .testFloat2)
        preferences.set([1, 2, 3], forKey: .testArray)
        
        XCTAssertEqual(preferences.get(.testString1), "abc")
        XCTAssertEqual(preferences.get(.testString2), "xyz")
        XCTAssertEqual(preferences.get(.testBool1), true)
        XCTAssertEqual(preferences.get(.testBool2), false)
        XCTAssertEqual(preferences.get(.testInt1), 123)
        XCTAssertEqual(preferences.get(.testInt2), 987)
        XCTAssertEqual(preferences.get(.testFloat1), 1.1)
        XCTAssertEqual(preferences.get(.testFloat2), 9.9)
        XCTAssertEqual(preferences.get(.testArray), [1, 2, 3])
    }
}

private extension DefaultsKeys {
    static let testString1 = DefaultsKey<String?>("testString1")
    static let testString2 = DefaultsKey<String?>("testString2")
    static let testBool1 = DefaultsKey<Bool?>("testBool1")
    static let testBool2 = DefaultsKey<Bool?>("testBool2")
    static let testInt1 = DefaultsKey<Int?>("testInt1")
    static let testInt2 = DefaultsKey<Int?>("testInt2")
    static let testFloat1 = DefaultsKey<Float?>("testFloat1")
    static let testFloat2 = DefaultsKey<Float?>("testFloat2")
    static let testArray = DefaultsKey<[Int]?>("testArray")
}
