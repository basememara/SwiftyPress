//
//  Constants.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL
import ZamzamCore

public struct Constants: AppInfo {
    private let service: ConstantsService
    
    public init(service: ConstantsService) {
        self.service = service
    }
}

public extension Constants {
    var isDebug: Bool { service.isDebug }
}

public extension Constants {
    var itunesName: String { service.itunesName }
    var itunesID: String { service.itunesID }
}

public extension Constants {
    var baseURL: URL { service.baseURL }
    var baseREST: String { service.baseREST }
    var wpREST: String { service.wpREST }
}

public extension Constants {
    var email: String { service.email }
    var privacyURL: String { service.privacyURL }
    var disclaimerURL: String? { service.disclaimerURL }
    var styleSheet: String { service.styleSheet }
    var googleAnalyticsID: String? { service.googleAnalyticsID }
}

public extension Constants {
    var featuredCategoryID: Int { service.featuredCategoryID }
    var defaultFetchModifiedLimit: Int { service.defaultFetchModifiedLimit }
    var taxonomies: [String] { service.taxonomies }
    var postMetaKeys: [String] { service.postMetaKeys }
}

public extension Constants {
    var minLogLevel: LogAPI.Level { service.minLogLevel }
}

public extension Constants {
    var itunesURL: String { "https://itunes.apple.com/app/id\(itunesID)" }
}
