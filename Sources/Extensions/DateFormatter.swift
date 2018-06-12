//
//  DateFormatter.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import Foundation

extension DateFormatter {
    
    static var iso8601: DateFormatter = {
        DateFormatter().with {
            $0.locale = .posix
            $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        }
    }()
}
