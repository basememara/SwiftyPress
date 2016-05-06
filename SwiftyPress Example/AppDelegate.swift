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
class AppDelegate: UIResponder, UIApplicationDelegate, ApplicationPressable {

    var window: UIWindow?

    override init() {
        super.init()
        AppGlobal.userDefaults.registerSite("Sites/naturesnurtureblog")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return didFinishLaunchingSite()
    }
}