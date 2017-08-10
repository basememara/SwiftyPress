//
//  AppGlobal.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/30/16.
//
//

import Foundation
import ZamzamKit
import RealmSwift
import RateLimit

public struct AppGlobal {
    
    public static let userDefaults = UserDefaults.standard
    static let postRefreshLimit = TimedLimiter(limit: 10800)
    static let termRefreshLimit = TimedLimiter(limit: 10800)
    
    // Prevent others from initializing singleton
    fileprivate init() { }
}

/// Check if app is running in debug mode.
var isInDebuggingMode: Bool {
    // http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
    #if DEBUG
        return true
    #else
        return false
    #endif
}
