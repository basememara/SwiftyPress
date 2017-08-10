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
    
    static let appName = DefaultsKey<String>("appName")
    static let itunesName = DefaultsKey<String>("itunesName")
    static let itunesID = DefaultsKey<String>("itunesID")
    static let baseURL = DefaultsKey<String>("baseURL")
    static let baseREST = DefaultsKey<String>("baseREST")
    static let wpREST = DefaultsKey<String>("wpREST")
    static let postRESTPrefix = DefaultsKey<String>("postRESTPrefix")
    static let baseDirectory = DefaultsKey<String>("baseDirectory")
    static let email = DefaultsKey<String>("email")
    static let darkMode = DefaultsKey<Bool>("darkMode")
    static let defaultTagFilter = DefaultsKey<Bool>("defaultTagFilter")
    static let tintColor = DefaultsKey<String>("tintColor")
    static let titleColor = DefaultsKey<String>("titleColor")
    static let secondaryTintColor = DefaultsKey<String>("secondaryTintColor")
    static let tabTitleColor = DefaultsKey<String>("tabTitleColor")
    static let headerImage = DefaultsKey<String>("headerImage")
    static let styleSheet = DefaultsKey<String>("styleSheet")
    static let googleAnalyticsID = DefaultsKey<String>("googleAnalyticsID")
    static let featuredCategoryID = DefaultsKey<Int>("featuredCategoryID")
    static let collectionCellCornerRadius = DefaultsKey<Int>("collectionCellCornerRadius")
    static let collectionCellShadowRadius = DefaultsKey<Int>("collectionCellShadowRadius")
    
    static let moreMenu = DefaultsKey<[[String: Any]]>("moreMenu")
    static let otherMenu = DefaultsKey<[[String: Any]]>("otherMenu")
    static let social = DefaultsKey<[[String: Any]]>("social")
    static let tutorial = DefaultsKey<[[String: Any]]>("tutorial")
    static let searchHistory = DefaultsKey<[String]>("searchHistory")
    
    static let isTutorialFinished = DefaultsKey<Bool>("isTutorialFinished")
    static let favorites = DefaultsKey<[Int]>("favorites")
}

public extension UserDefaults {
    /**
     Register a site by retrieving all settings for the specified path

     - parameter baseDirectory: The base directory used to grab settins, templates, and other resources.
     - parameter plistName: Property list where defaults are declared. Settings.plist is the default.
     */
    func registerSite(_ baseDirectory: String = "Site") {
        self[.baseDirectory] = baseDirectory
        self.register(plist: "Settings.plist", inDirectory: baseDirectory)
    }
}

// MARK: - Add array of dictionary support
// https://github.com/radex/SwiftyUserDefaults/pull/88
public extension UserDefaults {
    subscript(key: DefaultsKey<[[String: Any]]>) -> [[String: Any]] {
        get { return array(forKey: key._key) as? [[String: Any]] ?? [[:]] }
        set { set(key, newValue) }
    }
}
