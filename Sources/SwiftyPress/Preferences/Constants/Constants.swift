//
//  Constants.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct Constants: ConstantsType {
    private let store: ConstantsStore
    
    public init(store: ConstantsStore) {
        self.store = store
    }
}

public extension Constants {
    var environment: Environment { store.environment}
}

public extension Constants {
    var itunesName: String { store.itunesName }
    var itunesID: String { store.itunesID }
}

public extension Constants {
    var baseURL: URL { store.baseURL }
    var baseREST: String { store.baseREST }
    var wpREST: String { store.wpREST }
}

public extension Constants {
    var email: String { store.email }
    var privacyURL: String { store.privacyURL }
    var disclaimerURL: String? { store.disclaimerURL }
    var styleSheet: String { store.styleSheet }
    var googleAnalyticsID: String? { store.googleAnalyticsID }
}

public extension Constants {
    var featuredCategoryID: Int { store.featuredCategoryID }
    var defaultFetchModifiedLimit: Int { store.defaultFetchModifiedLimit }
    var taxonomies: [String] { store.taxonomies }
    var postMetaKeys: [String] { store.postMetaKeys }
}

public extension Constants {
    var minLogLevel: LogAPI.Level { store.minLogLevel }
}
