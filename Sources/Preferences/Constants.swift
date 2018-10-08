//
//  Constants.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-21.
//

import Foundation

public struct Constants: ConstantsType {
    private let store: ConstantsStore
    
    public init(store: ConstantsStore) {
        self.store = store
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
    
    var featuredCategoryID: Int {
        return store.featuredCategoryID
    }
}

public extension Constants {
    
    var logFileName: String {
        return store.logFileName
    }
    
    var logDNAKey: String? {
        return store.logDNAKey
    }
}
