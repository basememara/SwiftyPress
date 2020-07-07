//
//  TestConfigurator.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if !os(watchOS)
import Foundation.NSJSONSerialization
import Foundation.NSURL
import ZamzamCore
@testable import SwiftyPress

struct TestCore: SwiftyPressCore {
    
    func constantsService() -> ConstantsService {
        ConstantsMemoryService(
            isDebug: true,
            itunesName: "",
            itunesID: "0",
            baseURL: URL(string: "https://basememara.com")!,
            baseREST: "wp-json/swiftypress/v5",
            wpREST: "wp-json/wp/v2",
            email: "test@example.com",
            privacyURL: "",
            disclaimerURL: nil,
            styleSheet: "",
            googleAnalyticsID: nil,
            featuredCategoryID: 64,
            defaultFetchModifiedLimit: 25,
            taxonomies: ["category", "post_tag", "series"],
            postMetaKeys: ["_edit_lock", "_series_part"],
            minLogLevel: .verbose
        )
    }
    
    func preferencesService() -> PreferencesService {
        PreferencesDefaultsService(defaults: .test)
    }
    
    func logServices() -> [LogService] {
        [LogConsoleService(minLevel: .verbose)]
    }
    
    func dataSeed() -> DataSeed {
        DataJSONSeed()
    }
    
    func theme() -> Theme {
        fatalError("Not implemented")
    }
}
#endif
