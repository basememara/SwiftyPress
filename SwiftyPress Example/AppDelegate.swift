//
//  AppDelegate.swift
//  SwiftyPress Example
//
//  Created by Basem Emara on 3/27/16.
//
//

import UIKit
import SwiftyPress

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppPressable {

    var window: UIWindow?

    override init() {
        super.init()
        AppGlobal.userDefaults.registerSite()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return didFinishLaunchingSite(application, launchOptions: launchOptions)
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        return continueUserActivity(application, continueUserActivity: userActivity, restorationHandler: restorationHandler)
    }
}