//
//  TestConfigurator.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Shank
import ZamzamCore
@testable import SwiftyPress

struct TestModule: Module {

    func register() {
        make {
            ConstantsMemoryStore(
                environment: {
                    #if DEBUG
                    return .development
                    #elseif STAGING
                    return .staging
                    #else
                    return .production
                    #endif
                }(),
                itunesName: "",
                itunesID: "0",
                baseURL: URL(string: "https://basememara.com")!,
                baseREST: "wp-json/swiftypress/v5",
                wpREST: "wp-json/wp/v2",
                email: "",
                privacyURL: "",
                disclaimerURL: nil,
                styleSheet: "",
                googleAnalyticsID: nil,
                featuredCategoryID: 64,
                defaultFetchModifiedLimit: 25,
                taxonomies: ["category", "post_tag", "series"],
                postMetaKeys: ["_edit_lock", "_series_part"],
                logFileName: "test"
            ) as ConstantsStore
        }
        make { PreferencesDefaultsStore(defaults: .test) as PreferencesStore }
        make { SeedJSONStore(jsonString: jsonString) as SeedStore }
    }
}

private extension TestModule {
    
    struct SeedJSONStore: SeedStore {
        private static var data: SeedPayloadType?
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
        
        func fetch(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
            completion(.success(Self.data ?? SeedPayload()))
        }
    }
}
