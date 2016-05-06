//
//  UserDefaults.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/30/16.
//
//
import Foundation
import SwiftyUserDefaults

public extension DefaultsKeys {
    
    public static let appName = DefaultsKey<String>("appName")
    public static let itunesName = DefaultsKey<String>("itunesName")
    public static let itunesID = DefaultsKey<String>("itunesID")
    public static let baseURL = DefaultsKey<String>("baseURL")
    public static let baseREST = DefaultsKey<String>("baseREST")
    public static let baseDirectory = DefaultsKey<String>("baseDirectory")
    public static let email = DefaultsKey<String>("email")
    public static let darkMode = DefaultsKey<Bool>("darkMode")
    public static let tintColor = DefaultsKey<String>("tintColor")
    public static let titleColor = DefaultsKey<String>("titleColor")
    public static let changeMainTabTitleColor = DefaultsKey<Bool>("changeMainTabTitleColor")
    public static let imagePlaceholderURL = DefaultsKey<String>("imagePlaceholderURL")
    public static let designedBy = DefaultsKey<String>("designedBy")
    public static let designedByURL = DefaultsKey<String>("designedByURL")
    
    public static let categories = DefaultsKey<[[String: AnyObject]]>("categories")
    public static let moreMenu = DefaultsKey<[[String: AnyObject]]>("moreMenu")
    public static let social = DefaultsKey<[[String: AnyObject]]>("social")
    public static let tutorial = DefaultsKey<[[String: AnyObject]]>("tutorial")
    public static let searchHistory = DefaultsKey<[String]>("searchHistory")
}

public extension NSUserDefaults {
    /**
     Register a site by retrieving all settings for the specified path

     - parameter baseDirectory: The base directory used to grab settins, templates, and other resources.
     - parameter plistName: Property list where defaults are declared. Settings.plist is the default.
     */
    public func registerSite(baseDirectory: String) {
        self[.baseDirectory] = baseDirectory
        self.registerDefaults("Settings.plist", inDirectory: baseDirectory)
    }
}

// MARK: - Add array of dictionary support
// https://github.com/radex/SwiftyUserDefaults/pull/88
public extension NSUserDefaults {
    public subscript(key: DefaultsKey<[[String: AnyObject]]>) -> [[String: AnyObject]] {
        get {
            return arrayForKey(key._key) as? [[String: AnyObject]] ?? [[:]]
        }
        set { set(key, newValue) }
    }
}