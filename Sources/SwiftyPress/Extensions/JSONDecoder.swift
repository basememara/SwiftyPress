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
