//
//  AppDelegate.swift
//  SwiftyPress Example
//
//  Created by Basem Emara on 3/27/16.
//
//

import UIKit
import SwiftyPress
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppPressable {

    var window: UIWindow?

    override init() {
        super.init()
        AppGlobal.userDefaults.registerSite()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return didFinishLaunchingSite(application, launchOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return continueUserActivity(application, userActivity: userActivity, restorationHandler: restorationHandler)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        performFetch(application, completionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        didReceiveUserNotification(response: response, withCompletionHandler: completionHandler)
    }
}
