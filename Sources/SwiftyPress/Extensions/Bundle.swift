//
//  Bundle.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in SwiftyPress bundle directory on disk.
    static let swiftyPress: Bundle = {
        // Bundle should be explicitly added to main project until SPM supports resources
        // https://bugs.swift.org/browse/SR-2866
        guard let url = Bundle.main.url(forResource: "SwiftyPress", withExtension: "bundle"),
            let bundle = Bundle(url: url) else {
                return Bundle(for: TempClassForBundle.self)
        }
        
        return bundle
    }()
}
