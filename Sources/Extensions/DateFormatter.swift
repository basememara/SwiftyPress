//
//  DateFormatter.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

extension DateFormatter {
    
    static let iso8601 = DateFormatter().with {
        $0.calendar = Calendar(identifier: .iso8601)
        $0.locale = .posix
        $0.timeZone = .posix
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        // TODO: One day hopefully use this
        // https://bugs.swift.org/browse/SR-5823
        /*ISO8601DateFormatter().with {
            $0.formatOptions = [.withInternetDateTime]
         }*/
    }
}
