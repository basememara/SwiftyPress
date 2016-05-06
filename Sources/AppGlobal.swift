//
//  AppGlobal.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/30/16.
//
//

import Foundation
import ZamzamKit

public struct AppGlobal {
    
    public static let pressManager = PressManager()
    public static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // Prevent others from initializing singleton
    private init() { }
}