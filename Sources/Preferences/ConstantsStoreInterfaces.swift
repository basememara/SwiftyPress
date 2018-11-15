//
//  ConstantsStoreInterfaces.swift
//  SwiftyPress iOS
//
//  Created by Basem Emara on 2018-10-03.
//

import ZamzamKit

public protocol ConstantsStore: AppInfo {
    var environment: Environment { get }
    var itunesName: String { get }
    var itunesID: String { get }
    var baseURL: URL { get }
    var baseREST: String { get }
    var wpREST: String { get }
    var email: String { get }
    var privacyURL: String { get }
    var disclaimerURL: String? { get }
    var styleSheet: String { get }
    var googleAnalyticsID: String? { get }
    var featuredCategoryID: Int { get }
    var logFileName: String { get }
    var logDNAKey: String? { get }
}

public protocol ConstantsType: ConstantsStore {
    
}

public extension ConstantsType {
    
    var itunesURL: String {
        return "https://itunes.apple.com/app/id\(itunesID)"
    }
}
