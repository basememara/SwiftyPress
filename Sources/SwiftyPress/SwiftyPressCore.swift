//
//  SwiftyPressConfigurator.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.v
//

import Foundation
import ZamzamCore
import ZamzamUI

public protocol SwiftyPressCore {
    func dependency() -> ConstantsType
    func dependencyStore() -> ConstantsStore
    
    func dependency() -> PreferencesType
    func dependencyStore() -> PreferencesStore
    
    func dependency() -> DataProviderType
    func dependency() -> SeedStore
    func dependency() -> RemoteStore
    func dependency() -> CacheStore
    
    func dependency() -> PostProviderType
    func dependency() -> PostStore
    func dependency() -> PostRemote
    
    func dependency() -> AuthorProviderType
    func dependency() -> AuthorStore
    func dependency() -> AuthorRemote
    
    func dependency() -> MediaProviderType
    func dependency() -> MediaStore
    func dependency() -> MediaRemote
    
    func dependency() -> TaxonomyProviderType
    func dependencyStore() -> TaxonomyStore
    
    func dependency() -> APISessionType
    func dependency() -> HTTPServiceType
    
    func dependency() -> LogProviderType
    func dependency() -> [LogStore]
    
    func dependency() -> NotificationCenter
    func dependency() -> FileManager
    func dependency() -> JSONDecoder
    
    func dependency() -> Theme
    
    #if os(iOS)
    @available(iOS 10.0, *)
    func dependency(delegate: MailComposerDelegate?) -> MailComposerType
    #endif
}

public extension SwiftyPressCore {
    
    func dependency() -> ConstantsType {
        Constants(store: dependencyStore())
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> PreferencesType {
        Preferences(store: dependencyStore())
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> DataProviderType {
        DataProvider(
            constants: dependency(),
            seedStore: dependency(),
            remoteStore: dependency(),
            cacheStore: dependency(),
            log: dependency()
        )
    }
    
    func dependency() -> RemoteStore {
        RemoteNetworkStore(
            apiSession: dependency(),
            jsonDecoder: dependency(),
            log: dependency()
        )
    }
    
    func dependency() -> CacheStore {
        CacheRealmStore(
            fileManager: dependency(),
            preferences: dependency(),
            log: dependency()
        )
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> PostProviderType {
        PostProvider(
            store: dependency(),
            remote: dependency(),
            preferences: dependency(),
            constants: dependency(),
            dataProvider: dependency(),
            log: dependency()
        )
    }
    
    func dependency() -> PostStore {
        PostRealmStore(log: dependency())
    }
    
    func dependency() -> PostRemote {
        PostNetworkRemote(
            apiSession: dependency(),
            jsonDecoder: dependency(),
            log: dependency()
        )
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> AuthorProviderType {
        AuthorProvider(
            store: dependency(),
            remote: dependency(),
            log: dependency()
        )
    }
    
    func dependency() -> AuthorStore {
        AuthorRealmStore()
    }
    
    func dependency() -> AuthorRemote {
        AuthorNetworkRemote(
            apiSession: dependency(),
            jsonDecoder: dependency(),
            log: dependency()
        )
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> MediaProviderType {
        MediaProvider(
            store: dependency(),
            remote: dependency()
        )
    }
    
    func dependency() -> MediaStore {
        MediaRealmStore(log: dependency())
    }
    
    func dependency() -> MediaRemote {
        MediaNetworkRemote(
            apiSession: dependency(),
            jsonDecoder: dependency(),
            log: dependency()
        )
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> TaxonomyProviderType {
        TaxonomyProvider(
            store: dependencyStore(),
            dataProvider: dependency()
        )
    }
    
    func dependencyStore() -> TaxonomyStore {
        TaxonomyRealmStore(log: dependency())
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> APISessionType {
        APISession(
            constants: dependency(),
            log: dependency()
        )
    }
    
    func dependency() -> HTTPServiceType {
        HTTPService()
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> LogProviderType {
        LogProvider(stores: dependency())
    }
}

public extension SwiftyPressCore {
    
    func dependency() -> NotificationCenter {
        .default
    }
    
    func dependency() -> FileManager {
        .default
    }
    
    func dependency() -> JSONDecoder {
        .default
    }
}

public extension SwiftyPressCore {
    
    #if os(iOS)
    @available(iOS 10.0, *)
    func dependency(delegate: MailComposerDelegate? = nil) -> MailComposerType {
        let theme: Theme = dependency()
        
        return MailComposer(
            delegate: delegate,
            styleNavigationBar: {
                $0.tintColor = theme.tint
            }
        )
    }
    #endif
}
