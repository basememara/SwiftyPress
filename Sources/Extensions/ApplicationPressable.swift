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

public protocol ApplicationPressable {

    var window: UIWindow? { get set }
}

public extension ApplicationPressable {

    /**
     Configures application for currently launched site.

     - parameter application: Singleton app object.
     - parameter launchOptions: A dictionary indicating the reason the app was launched (if any).

     - returns: False if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
     */
    public func didFinishLaunchingSite(application: UIApplication, launchOptions: [NSObject: AnyObject]?) -> Bool {
        let handleRequest = true
        
        window?.tintColor = UIColor(rgb: AppGlobal.userDefaults[.tintColor])
        
        if !AppGlobal.userDefaults[.titleColor].isEmpty {
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor(rgb: AppGlobal.userDefaults[.titleColor])
            ]
        }
        
        // Configure tab bar
        if let controller = window?.rootViewController as? UITabBarController {
            controller.selectedIndex = 2
            
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
    
        return handleRequest
    }
    
    /**
     Tells the delegate that the data for continuing an activity is available.

     - parameter application: Your shared app object.
     - parameter userActivity: The activity object containing the data associated with the task the user was performing. Use the data in this object to recreate what the user was doing.
     - parameter restorationHandler: A block to execute if your app creates objects to perform the task. Calling this block is optional and you can copy this block and call it at a later time. When calling a saved copy of the block, you must call it from the app’s main thread.

     - returns: True to indicate that your app handled the activity or false to let iOS know that your app did not handle the activity.
     */
    public func continueUserActivity(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: (([AnyObject]?) -> Void)? = nil) -> Bool {
        // Get root container and extract path from URL if applicable
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let url = userActivity.webpageURL,
            let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false),
            let path = url.path?.lowercaseString
                where userActivity.activityType == NSUserActivityTypeBrowsingWeb
                    else { return false }
        
        // Handle search if applicable
        if let query = urlComponents.queryItems?.first({ $0.name == "s" })?.value {
            tabBarController.selectedIndex = 3
            
            guard let navigationController = tabBarController.selectedViewController as? UINavigationController,
                let controller = navigationController.topViewController as? SearchViewController else { return false }
            
            // Execute process in the right lifecycle moment
            controller.restorationHandlers.append({
                controller.applySearch(query)
            })
        } else {
            // Attempt wildcard path
            tabBarController.selectedIndex = 2
            
            guard let navigationController = tabBarController.selectedViewController as? UINavigationController
                else { return false }
            
            // Extract slug from URL if applicable
            let slug = path.lowercaseString
                .replaceRegEx("\\d{4}/\\d{2}/\\d{2}/", replaceValue: "") // Handle legacy permalinks
                .stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "/"))
            
            guard let post = AppGlobal.realm?.objects(Post).filter("slug == '\(slug)'").first else {
                let urlString = urlComponents.addOrUpdateQueryStringParameter("mobileembed", value: "1")
                    ?? AppGlobal.userDefaults[.baseURL]
                
                // Display browser if post not found
                navigationController.pushViewController(
                    SFSafariViewController(URL: NSURL(string: urlString)!), animated: false)
                return true
            }
            
            // Push post detail view
            let storyboard = UIStoryboard(name: "PostDetail", bundle: NSBundle(forClass: PostDetailViewController.self))
            if let detailController = storyboard
                .instantiateViewControllerWithIdentifier("PostDetailViewController") as? PostDetailViewController {
                    detailController.model = post
                    detailController.title = AppGlobal.userDefaults[.appName].uppercaseString
                    detailController.hidesBottomBarWhenPushed = true
                    navigationController.pushViewController(detailController, animated: false)
            }
        }
        
        return true
    }
}