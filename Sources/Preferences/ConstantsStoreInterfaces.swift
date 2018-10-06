//
//  ConstantsStoreInterfaces.swift
//  SwiftyPress iOS
//
//  Created by Basem Emara on 2018-10-03.
//

import Foundation

public protocol ConstantsStore {
    var itunesName: String { get }
    var itunesID: String { get }
    var baseURL: URL { get }
    var baseREST: String { get }
    var wpREST: String { get }
    var email: String { get }
    var styleSheet: String { get }
    var googleAnalyticsID: String? { get }
    var featuredCategoryID: Int { get }
    var logFileName: String { get }
    var logDNAKey: String? { get }
}

public protocol ConstantsType: ConstantsStore {
    
}
