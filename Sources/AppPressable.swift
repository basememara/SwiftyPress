//
//  UIApplicationDelegate.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation
import SafariServices
import ZamzamKit
import RealmSwift
import JASON

public protocol AppPressable: Navigable {

    var window: UIWindow? { get set }
}

public extension AppPressable {

    /**
     Configures application for currently launched site.

     - parameter application: Singleton app object.
     - parameter launchOptions: A dictionary indicating the reason the app was launched (if any).

     - returns: False if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
     */
    func didFinishLaunchingSite(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize Google Analytics
        if !AppGlobal.userDefaults[.googleAnalyticsID].isEmpty {
            GAI.sharedInstance().tracker(
                withTrackingId: AppGlobal.userDefaults[.googleAnalyticsID])
        }
        
        // Declare data format from remote REST API
        JSON.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // Seed database if applicable
        setupDatabase()
        
        // Select home tab
        (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
        
        applyTheme()
    
        return true
    }
    
    /**
     Tells the delegate that the data for continuing an activity is available.

     - parameter application: Your shared app object.
     - parameter userActivity: The activity object containing the data associated with the task the user was performing. Use the data in this object to recreate what the user was doing.
     - parameter restorationHandler: A block to execute if your app creates objects to perform the task. Calling this block is optional and you can copy this block and call it at a later time. When calling a saved copy of the block, you must call it from the app’s main thread.

     - returns: True to indicate that your app handled the activity or false to let iOS know that your app did not handle the activity.
     */
    func continueUserActivity(_ application: UIApplication, userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return navigateByURL(userActivity.webpageURL)
        }
        
        return true
    }
}

private extension AppPressable {

    func setupDatabase() {
        // Validate if already seeded
        guard let realmFileURL = Realm.Configuration.defaultConfiguration.fileURL, !FileManager.default.fileExists(atPath: realmFileURL.path) else { return }
        
        // Determine source of seed data
        guard let seedFileURL = Bundle.main.url(forResource: "seed", withExtension: "realm", subdirectory: "\(AppGlobal.userDefaults[.baseDirectory])/data"),
            FileManager.default.fileExists(atPath: seedFileURL.path) else {
                // Construct from a series of REST requests
                PostService().seedFromRemote()
                return
            }
        
        // Use pre-created seed database
        do { try FileManager.default.copyItem(at: seedFileURL, to: realmFileURL) }
        catch { /*TODO: Log error*/ }
    }

    func applyTheme() {
        window?.tintColor = UIColor(rgb: AppGlobal.userDefaults[.tintColor])
        
        if !AppGlobal.userDefaults[.titleColor].isEmpty {
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor(rgb: AppGlobal.userDefaults[.titleColor])
            ]
        }
        
        // Configure tab bar
        if let controller = window?.rootViewController as? UITabBarController {
            controller.tabBar.items?.get(1)?.image = UIImage(named: "top-charts", inBundle: AppConstants.bundle)
            controller.tabBar.items?.get(1)?.selectedImage = UIImage(named: "top-charts-filled", inBundle: AppConstants.bundle)
            controller.tabBar.items?.get(2)?.image = UIImage(named: "explore", inBundle: AppConstants.bundle)
            controller.tabBar.items?.get(2)?.selectedImage = UIImage(named: "explore-filled", inBundle: AppConstants.bundle)
            
            if !AppGlobal.userDefaults[.tabTitleColor].isEmpty {
                UITabBarItem.appearance().setTitleTextAttributes([
                    NSForegroundColorAttributeName: UIColor(rgb: AppGlobal.userDefaults[.tabTitleColor])
                ], for: .selected)
           }
        }
        
        // Configure dark mode if applicable
        if AppGlobal.userDefaults[.darkMode] {
            UINavigationBar.appearance().barStyle = .black
            UITabBar.appearance().barStyle = .black
            UICollectionView.appearance().backgroundColor = .black
            UITableView.appearance().backgroundColor = .black
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
}
