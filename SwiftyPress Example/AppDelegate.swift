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
        
        /*let realm = try! Realm()
        realm.beginWrite()
        realm.deleteAll()
        try! realm.commitWrite()*/
        
        
        AppGlobal.userDefaults.registerSite("Sites/naturesnurtureblog")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return didFinishLaunchingSite()
    }
}