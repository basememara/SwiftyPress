//
//  UIApplicationDelegate.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation

public protocol ApplicationPressable {

    var window: UIWindow? { get set }
}

public extension ApplicationPressable {

    public func didFinishLaunchingSite() -> Bool {
        let handleRequest = true
        
        window?.tintColor = UIColor(rgb: AppGlobal.userDefaults[.tintColor])
        
        // Configure tab bar
        if let controller = window?.rootViewController as? UITabBarController {
            controller.selectedIndex = 2
            
            controller.tabBar.items?.get(1)?.image = UIImage(named: "top-charts", inBundle: AppConstants.bundle)
            controller.tabBar.items?.get(1)?.selectedImage = UIImage(named: "top-charts-filled", inBundle: AppConstants.bundle)
            controller.tabBar.items?.get(2)?.image = UIImage(named: "explore", inBundle: AppConstants.bundle)
            controller.tabBar.items?.get(2)?.selectedImage = UIImage(named: "explore-filled", inBundle: AppConstants.bundle)
        }
    
        return handleRequest
    }
}