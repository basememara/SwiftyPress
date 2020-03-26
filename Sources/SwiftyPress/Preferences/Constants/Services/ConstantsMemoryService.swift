//
//  ConstantsMemoryService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL
import ZamzamCore

public struct ConstantsMemoryService: ConstantsService {
    public let environment: Environment
    public let itunesName: String
    public let itunesID: String
    public let baseURL: URL
    public let baseREST: String
    public let wpREST: String
    public let email: String
    public let privacyURL: String
    public let disclaimerURL: String?
    public let styleSheet: String
    public let googleAnalyticsID: String?
    public let featuredCategoryID: Int
    public let defaultFetchModifiedLimit: Int
    public let taxonomies: [String]
    public let postMetaKeys: [String]
    public let minLogLevel: LogAPI.Level
    
    public init(
        environment: Environment,
        itunesName: String,
        itunesID: String,
        baseURL: URL,
        baseREST: String,
        wpREST: String,
        email: String,
        privacyURL: String,
        disclaimerURL: String?,
        styleSheet: String,
        googleAnalyticsID: String?,
        featuredCategoryID: Int,
        defaultFetchModifiedLimit: Int,
        taxonomies: [String],
        postMetaKeys: [String],
        minLogLevel: LogAPI.Level
    ) {
        self.environment = environment
        self.itunesName = itunesName
        self.itunesID = itunesID
        self.baseURL = baseURL
        self.baseREST = baseREST
        self.wpREST = wpREST
        self.email = email
        self.privacyURL = privacyURL
        self.disclaimerURL = disclaimerURL
        self.styleSheet = styleSheet
        self.googleAnalyticsID = googleAnalyticsID
        self.featuredCategoryID = featuredCategoryID
        self.defaultFetchModifiedLimit = defaultFetchModifiedLimit
        self.taxonomies = taxonomies
        self.postMetaKeys = postMetaKeys
        self.minLogLevel = minLogLevel
    }
}
