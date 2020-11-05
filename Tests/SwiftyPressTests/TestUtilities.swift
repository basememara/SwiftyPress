//
//  TestUtilities.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if !os(watchOS)
import Foundation

extension UserDefaults {
    static let test = UserDefaults(suiteName: "SwiftyPressTests")!
}

extension JSONDecoder {
    
    /// Decodes the given type from the given JSON representation of the current file.
    func decode<T>(_ type: T.Type, fromJSON file: String, suffix: String? = nil) throws -> T where T : Decodable {
        let fileName = URL(fileURLWithPath: file)
            .appendingToFileName(suffix ?? "")
            .deletingPathExtension()
            .lastPathComponent
        
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            throw NSError(domain: "SwiftyPressTests.JSONDecoder", code: NSFileReadUnknownError)
        }
        
        return try decode(type, from: data)
    }
}

extension Result {

    var value: Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
}
#endif
