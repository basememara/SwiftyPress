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

public struct AppGlobal {
    
    public static let pressManager = PressManager()
    public static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    public static var realm: Realm? = {
        do {
            return try Realm()
        } catch {
            // TODO: Log error
            return nil
        }
    }()
    
    // Prevent others from initializing singleton
    private init() { }
}