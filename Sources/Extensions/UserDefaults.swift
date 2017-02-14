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
    public static let wpREST = DefaultsKey<String>("wpREST")
    public static let baseDirectory = DefaultsKey<String>("baseDirectory")
    public static let email = DefaultsKey<String>("email")
    public static let darkMode = DefaultsKey<Bool>("darkMode")
    public static let defaultTagFilter = DefaultsKey<Bool>("defaultTagFilter")
    public static let tintColor = DefaultsKey<String>("tintColor")
    public static let titleColor = DefaultsKey<String>("titleColor")
    public static let secondaryTintColor = DefaultsKey<String>("secondaryTintColor")
    public static let tabTitleColor = DefaultsKey<String>("tabTitleColor")
    public static let headerImage = DefaultsKey<String>("headerImage")
    public static let styleSheet = DefaultsKey<String>("styleSheet")
    public static let googleAnalyticsID = DefaultsKey<String>("googleAnalyticsID")
    public static let featuredCategoryID = DefaultsKey<Int>("featuredCategoryID")
    public static let collectionCellCornerRadius = DefaultsKey<Int>("collectionCellCornerRadius")
    public static let collectionCellShadowRadius = DefaultsKey<Int>("collectionCellShadowRadius")
    
    public static let moreMenu = DefaultsKey<[[String: Any]]>("moreMenu")
    public static let otherMenu = DefaultsKey<[[String: Any]]>("otherMenu")
    public static let social = DefaultsKey<[[String: Any]]>("social")
    public static let tutorial = DefaultsKey<[[String: Any]]>("tutorial")
    public static let searchHistory = DefaultsKey<[String]>("searchHistory")
    
    public static let isTutorialFinished = DefaultsKey<Bool>("isTutorialFinished")
    public static let favorites = DefaultsKey<[Int]>("favorites")
}

public extension UserDefaults {
    /**
     Register a site by retrieving all settings for the specified path

     - parameter baseDirectory: The base directory used to grab settins, templates, and other resources.
     - parameter plistName: Property list where defaults are declared. Settings.plist is the default.
     */
    public func registerSite(_ baseDirectory: String = "Site") {
        self[.baseDirectory] = baseDirectory
        self.registerDefaults("Settings.plist", inDirectory: baseDirectory)
    }
}

// MARK: - Add array of dictionary support
// https://github.com/radex/SwiftyUserDefaults/pull/88
public extension UserDefaults {
    public subscript(key: DefaultsKey<[[String: Any]]>) -> [[String: Any]] {
        get { return array(forKey: key._key) as? [[String: Any]] ?? [[:]] }
        set { set(key, newValue) }
    }
}
