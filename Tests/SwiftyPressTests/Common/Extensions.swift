//
//  TestHelpers.swift
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

extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in bundle directory on disk.
    static let test = Bundle(for: TempClassForBundle.self)
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
