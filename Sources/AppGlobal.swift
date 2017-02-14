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
