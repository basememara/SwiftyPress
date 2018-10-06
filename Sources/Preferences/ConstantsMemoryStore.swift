//
//  ConstantsStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-03.
//

import Foundation

public struct ConstantsMemoryStore: ConstantsStore {
    public let itunesName: String
    public let itunesID: String
    public let baseURL: URL
    public let baseREST: String
    public let wpREST: String
    public let email: String
    public let styleSheet: String
    public let googleAnalyticsID: String?
    public let featuredCategoryID: Int
    public let logFileName: String
    public let logDNAKey: String?
    
    public init(
        itunesName: String,
        itunesID: String,
        baseURL: URL,
        baseREST: String,
        wpREST: String,
        email: String,
        styleSheet: String,
        googleAnalyticsID: String?,
        featuredCategoryID: Int,
        logFileName: String,
        logDNAKey: String?)
    {
        self.itunesName = itunesName
        self.itunesID = itunesID
        self.baseURL = baseURL
        self.baseREST = baseREST
        self.wpREST = wpREST
        self.email = email
        self.styleSheet = styleSheet
        self.googleAnalyticsID = googleAnalyticsID
        self.featuredCategoryID = featuredCategoryID
        self.logFileName = logFileName
        self.logDNAKey = logDNAKey
    }
}
