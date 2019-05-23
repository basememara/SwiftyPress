//
//  Constants.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public struct Constants: ConstantsType {
    private let store: ConstantsStore
    
    public init(store: ConstantsStore) {
        self.store = store
    }
}

public extension Constants {
    
    var environment: Environment {
        return store.environment
    }
}

public extension Constants {
    
    var itunesName: String {
        return store.itunesName
    }
    
    var itunesID: String {
        return store.itunesID
    }
}

public extension Constants {
    
    var baseURL: URL {
        return store.baseURL
    }
    
    var baseREST: String {
        return store.baseREST
    }
    
    var wpREST: String {
        return store.wpREST
    }
}

public extension Constants {
    
    var email: String {
        return store.email
    }
    
    var privacyURL: String {
        return store.privacyURL
    }
    
    var disclaimerURL: String? {
        return store.disclaimerURL
    }
    
    var styleSheet: String {
        return store.styleSheet
    }
    
    var googleAnalyticsID: String? {
        return store.googleAnalyticsID
    }
}

public extension Constants {
    
    var featuredCategoryID: Int {
        return store.featuredCategoryID
    }
    
    var defaultFetchModifiedLimit: Int {
        return store.defaultFetchModifiedLimit
    }
    
    var taxonomies: [String] {
        return store.taxonomies
    }
    
    var postMetaKeys: [String] {
        return store.postMetaKeys
    }
}

public extension Constants {
    
    var logFileName: String {
        return store.logFileName
    }
}
