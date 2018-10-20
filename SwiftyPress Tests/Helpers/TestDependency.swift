//
//  TestDependency.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import SwiftyPress

class TestDependency: DependencyFactory {
    
    override func resolveStore() -> ConstantsStore {
        return ConstantsMemoryStore(
            itunesName: "",
            itunesID: "0",
            baseURL: URL(string: "https://basememara.com")!,
            baseREST: "wp-json/swiftypress/v3",
            wpREST: "wp-json/wp/v2",
            email: "",
            privacyURL: "",
            disclaimerURL: nil,
            styleSheet: "",
            googleAnalyticsID: nil,
            featuredCategoryID: 64,
            logFileName: "test",
            logDNAKey: nil
        )
    }
    
    override func resolveStore() -> PreferencesStore {
        return PreferencesDefaultsStore(
            defaults: TestUtils.shared.defaults
        )
    }
    
    override func resolveStore() -> SeedStore {
        return SeedFileStore(
            forResource: "seed1.json",
            inBundle: TestUtils.shared.bundle
        )
    }
}
