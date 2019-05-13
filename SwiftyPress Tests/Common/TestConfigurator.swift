//
//  TestConfigurator.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

class TestConfigurator: CoreConfigurator {
    private let environment: Environment
    
    override init() {
        // Declare environment mode
        self.environment = {
            #if DEBUG
            return .development
            #elseif STAGING
            return .staging
            #else
            return .production
            #endif
        }()
        
        super.init()
    }
    
    override func resolveStore() -> ConstantsStore {
        return ConstantsMemoryStore(
            environment: environment,
            itunesName: "",
            itunesID: "0",
            baseURL: URL(string: "https://basememara.com")!,
            baseREST: "wp-json/swiftypress/v4",
            wpREST: "wp-json/wp/v2",
            email: "",
            privacyURL: "",
            disclaimerURL: nil,
            styleSheet: "",
            googleAnalyticsID: nil,
            featuredCategoryID: 64,
            logFileName: "test"
        )
    }
    
    override func resolveStore() -> PreferencesStore {
        return PreferencesDefaultsStore(
            defaults: .test
        )
    }
    
    override func resolveStore() -> SeedStore {
        return SeedFileStore(
            forResource: "seed1.json",
            inBundle: .test
        )
    }
}
