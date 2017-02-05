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
import UserNotifications

public protocol AppPressable: Navigable {

    var window: UIWindow? { get set }
}

public extension AppPressable where Self: UIApplicationDelegate {

    /**
     Configures application for currently launched site.

     - parameter application: Singleton app object.
     - parameter launchOptions: A dictionary indicating the reason the app was launched (if any).

     - returns: False if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
     */
    func didFinishLaunchingSite(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Configure application
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        UNUserNotificationCenter.current().register()
        
        // Initialize Google Analytics
        if !AppGlobal.userDefaults[.googleAnalyticsID].isEmpty {
            GAI.sharedInstance().tracker(
                withTrackingId: AppGlobal.userDefaults[.googleAnalyticsID])
        }
        
        // Declare data format from remote REST API
        JSON.dateFormatter.dateFormat = ZamzamConstants.DateTime.JSON_FORMAT
        
        // Perform any one-time setup if needed
        UpdateKit().firstLaunch { setupDatabase() }
        
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
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else { return true }
        return navigateByURL(userActivity.webpageURL)
    }
    
    /// Tells the app that it can begin a fetch operation if it has data to download.
    ///
    /// - Parameters:
    ///   - application: Your shared app object.
    ///   - completionHandler: The block to execute when the download operation is complete.
    func performFetch(_ application: UIApplication, completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        scheduleUserNotifications(completionHandler: completionHandler)
    }
}

private extension AppPressable {

    func setupDatabase() {
        guard let realmFileURL = Realm.Configuration.defaultConfiguration.fileURL else { return }
        let fileManager = FileManager.default
        
        // Remove previous database to allow fresh data and schema to be recreated
        if fileManager.fileExists(atPath: realmFileURL.path) {
            // Handle database auxiliary files
            let folderPath = realmFileURL.deletingLastPathComponent().path
            do {
                try fileManager.contentsOfDirectory(atPath: folderPath)
                    .filter { $0.hasPrefix(realmFileURL.lastPathComponent) }
                    .forEach { try fileManager.removeItem(atPath: "\(folderPath)/\($0)") }
            } catch {
                // TODO: Log error
            }
        }
        
        // Seed data to fresh database
        guard let seedFileURL = Bundle.main.url(forResource: "seed", withExtension: "realm", subdirectory: "\(AppGlobal.userDefaults[.baseDirectory])/data"),
            fileManager.fileExists(atPath: seedFileURL.path) else {
                // Construct from a series of REST requests
                return PostService().seedFromRemote()
            }
        
        // Use pre-created seed database
        do { try fileManager.copyItem(at: seedFileURL, to: realmFileURL) }
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
    
    func scheduleUserNotifications(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Get latest posts from server
        PostService().updateFromRemote {
            guard case .success(let posts) = $0 else { return completionHandler(.failed) }
            guard let post = posts.first else { return completionHandler(.noData) }
            
            var title = "New post".localized
            var attachments = [UNNotificationAttachment]()
            
            // Append author name if applicable
            if let author = post.author?.name, !author.isEmpty {
                title += " \("by".localized) \(author)"
            }
            
            // Completion process on exit
            func deferred() {
                // Launch notification
                UNUserNotificationCenter.current().add(
                    timeInterval: 5,
                    body: post.title,
                    title: title,
                    attachments: attachments,
                    userInfo: ["link": post.link]
                )
                
                completionHandler(.newData)
            }
            
            // Get remote media to attach to notification
            guard let link = post.media?.thumbnailLink, let file = URL(string: link) else { return deferred() }
            let thread = Thread.current
            
            URLSession.shared.downloadTask(with: file) {
                defer { thread.async { deferred() } }
                guard let location = $0.0 else { return }
                
                // Construct file destination
                let temp = FileManager.default.temporaryDirectory.appendingPathComponent(file.lastPathComponent)
                _ = try? FileManager.default.removeItem(at: temp)
                
                // Store remote file locally
                guard let _ = try? FileManager.default.moveItem(at: location, to: temp),
                    let attachment = try? UNNotificationAttachment(identifier: link, url: temp)
                        else { return }
                
                attachments.append(attachment)
            }.resume()
        }
    }
}
