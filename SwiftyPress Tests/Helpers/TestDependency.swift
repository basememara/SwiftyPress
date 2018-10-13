//
//  TestDependency.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import SwiftyPress

class TestDependency: Dependency {
    
    override func resolveStore() -> PostsStore {
        return PostsMemoryStore(preferences: resolve())
    }
    
    override func resolveStore() -> TaxonomyStore {
        return TaxonomyMemoryStore()
    }
    
    override func resolveStore() -> AuthorsStore {
        return AuthorsMemoryStore()
    }
    
    override func resolveStore() -> MediaStore {
        return MediaMemoryStore()
    }
    
    override func resolveStore() -> ConstantsStore {
        return ConstantsMemoryStore(
            itunesName: "basememara",
            itunesID: "0",
            baseURL: URL(string: "https://basememara.com")!,
            baseREST: "wp-json/swiftypress/v3",
            wpREST: "wp-json/wp/v2",
            email: "contact@basememara.com",
            privacyURL: "https://basememara.com/privacy",
            disclaimerURL: nil,
            styleSheet: "http://basememara.com/wp-content/themes/metro-pro/style.css",
            googleAnalyticsID: nil,
            featuredCategoryID: 64,
            logFileName: "test",
            logDNAKey: nil
        )
    }
    
    override func resolveStore() -> PreferencesStore {
        return PreferencesDefaultsStore(
            defaults: UserDefaults(
                suiteName: TestUtils.shared.bundleIdentifier
            )!
        )
    }
}
