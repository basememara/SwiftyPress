//
//  JSONDecoder.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public extension JSONDecoder {
    
    static let `default` = JSONDecoder().with {
        $0.dateDecodingStrategy = .formatted(
            DateFormatter(iso8601Format: "yyyy-MM-dd'T'HH:mm:ss")
        )
        
        // TODO: One day hopefully use this
        // https://bugs.swift.org/browse/SR-5823
        /*ISO8601DateFormatter().with {
            $0.formatOptions = [.withInternetDateTime]
         }*/
    }
}

extension JSONDecoder {
    
    /// Returns a value of the type you specify, decoded from a JSON object.
    func decode<T>(_ type: T.Type, forResource name: String?, inBundle bundle: Bundle) throws -> T where T: Decodable {
        guard let url = bundle.url(forResource: name, withExtension: nil) else { throw DataError.nonExistent }
        
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            return try decode(type, from: data)
        } catch {
            throw DataError.parseFailure(error)
        }
    }
}
