//
//  SwiftyPress_ModelTests.swift
//  SwiftyPress ModelTests
//
//  Created by Basem Emara on 2019-05-11.
//

import XCTest
import ZamzamKit

extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in bundle directory on disk.
    static let test = Bundle(for: TempClassForBundle.self)
}

extension DateFormatter {
    static let iso8601 = DateFormatter(iso8601Format: "yyyy-MM-dd'T'HH:mm:ss")
}
