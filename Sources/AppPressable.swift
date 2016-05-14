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

public protocol AppPressable: Routable {

    var window: UIWindow? { get set }
}

public extension AppPressable {

    /**
     Configures application for currently launched site.

     - parameter application: Singleton app object.
     - parameter launchOptions: A dictionary indicating the reason the app was launched (if any).

     - returns: False if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
     */
    public func didFinishLaunchingSite(application: UIApplication, launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize Google Analytics
        if !AppGlobal.userDefaults[.googleAnalyticsID].isEmpty {
            GAI.sharedInstance().trackerWithTrackingId(
                AppGlobal.userDefaults[.googleAnalyticsID])
        }
        
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
    public func continueUserActivity(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: (([AnyObject]?) -> Void)? = nil) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return navigateByURL(userActivity.webpageURL)
        }
        
        return true
    }
}

private extension AppPressable {

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
                ], forState: .Selected)
           }
        }
        
        // Configure dark mode if applicable
        if AppGlobal.userDefaults[.darkMode] {
            UINavigationBar.appearance().barStyle = .Black
            UITabBar.appearance().barStyle = .Black
            UICollectionView.appearance().backgroundColor = .blackColor()
            UITableView.appearance().backgroundColor = .blackColor()
            UITableViewCell.appearance().backgroundColor = .clearColor()
        }
    }
}