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

struct TestsCore: SwiftyPressCore {
    
    func constantsService() -> ConstantsService {
        ConstantsMemoryService(
            environment: .development,
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
    
    func seedService() -> SeedService {
        SeedJSONService(jsonString: jsonString)
    }
    
    func theme() -> Theme {
        fatalError("Not implemented")
    }
}

private extension TestsCore {
    
    struct SeedJSONService: SeedService {
        private static var data: SeedPayload?
        private let jsonString: String
        
        init(jsonString: String) {
            self.jsonString = jsonString
        }
        
        func configure() {
            guard Self.data == nil,
                let data = jsonString.data(using: .utf8) else {
                    return
            }
            
            Self.data = try? JSONDecoder.default.decode(
                SeedPayload.self,
                from: data
            )
        }
        
        func fetch(completion: @escaping (Result<SeedPayload, SwiftyPressError>) -> Void) {
            completion(.success(Self.data ?? SeedPayload()))
        }
    }
}
#endif
