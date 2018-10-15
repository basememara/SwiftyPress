//
//  Bundle.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

public extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in SwiftyPress bundle directory on disk.
    static let swiftyPress = Bundle(for: TempClassForBundle.self)
}
