//
//  Environment.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-17.
//

public enum Environment: String {
    case development
    case staging
    case production
}

public extension Environment {
    
    /// Determine the current environment mode of the build
    static var mode: Environment {
        #if DEBUG
        return .development
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }
}
