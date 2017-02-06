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
    
    static var realm: Realm? = {
        do {
            return try Realm()
        } catch {
            Log(error: "Could not get a Realm instance: \(error).")
            return nil
        }
    }()
    
    // Prevent others from initializing singleton
    fileprivate init() { }
}
