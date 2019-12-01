//
//  SwiftyPressConfigurator.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.v
//

import Foundation
import UIKit
import ZamzamCore
import ZamzamUI

public protocol SwiftyPressModule {
    func component() -> ConstantsType
    func componentStore() -> ConstantsStore
    
    func component() -> PreferencesType
    func componentStore() -> PreferencesStore
    
    func component() -> DataProviderType
    func component() -> SeedStore
    func component() -> RemoteStore
    func component() -> CacheStore
    
    func component() -> PostProviderType
    func component() -> PostStore
    func component() -> PostRemote
    
    func component() -> AuthorProviderType
    func component() -> AuthorStore
    func component() -> AuthorRemote
    
    func component() -> MediaProviderType
    func component() -> MediaStore
    func component() -> MediaRemote
    
    func component() -> TaxonomyProviderType
    func componentStore() -> TaxonomyStore
    
    func component() -> APISessionType
    func component() -> HTTPServiceType
    
    func component() -> LogProviderType
    func component() -> [LogStore]
    
    func component() -> NotificationCenter
    func component() -> FileManager
    func component() -> JSONDecoder
    
    func component() -> Theme
    
    @available(iOS 10.0, *)
    func component(delegate: MailComposerDelegate?) -> MailComposerType
}

public extension SwiftyPressModule {
    
    func component() -> ConstantsType {
        Constants(store: componentStore())
    }
}

public extension SwiftyPressModule {
    
    func component() -> PreferencesType {
        Preferences(store: componentStore())
    }
}

public extension SwiftyPressModule {
    
    func component() -> DataProviderType {
        DataProvider(
            constants: component(),
            seedStore: component(),
            remoteStore: component(),
            cacheStore: component(),
            log: component()
        )
    }
    
    func component() -> RemoteStore {
        RemoteNetworkStore(
            apiSession: component(),
            jsonDecoder: component(),
            log: component()
        )
    }
    
    func component() -> CacheStore {
        CacheRealmStore(
            fileManager: component(),
            preferences: component(),
            log: component()
        )
    }
}

public extension SwiftyPressModule {
    
    func component() -> PostProviderType {
        PostProvider(
            store: component(),
            remote: component(),
            preferences: component(),
            constants: component(),
            dataProvider: component(),
            log: component()
        )
    }
    
    func component() -> PostStore {
        PostRealmStore(log: component())
    }
    
    func component() -> PostRemote {
        PostNetworkRemote(
            apiSession: component(),
            jsonDecoder: component(),
            log: component()
        )
    }
}

public extension SwiftyPressModule {
    
    func component() -> AuthorProviderType {
        AuthorProvider(
            store: component(),
            remote: component(),
            log: component()
        )
    }
    
    func component() -> AuthorStore {
        AuthorRealmStore()
    }
    
    func component() -> AuthorRemote {
        AuthorNetworkRemote(
            apiSession: component(),
            jsonDecoder: component(),
            log: component()
        )
    }
}

public extension SwiftyPressModule {
    
    func component() -> MediaProviderType {
        MediaProvider(
            store: component(),
            remote: component()
        )
    }
    
    func component() -> MediaStore {
        MediaRealmStore(log: component())
    }
    
    func component() -> MediaRemote {
        MediaNetworkRemote(
            apiSession: component(),
            jsonDecoder: component(),
            log: component()
        )
    }
}

public extension SwiftyPressModule {
    
    func component() -> TaxonomyProviderType {
        TaxonomyProvider(
            store: componentStore(),
            dataProvider: component()
        )
    }
    
    func componentStore() -> TaxonomyStore {
        TaxonomyRealmStore(log: component())
    }
}

public extension SwiftyPressModule {
    
    func component() -> APISessionType {
        APISession(
            constants: component(),
            log: component()
        )
    }
    
    func component() -> HTTPServiceType {
        HTTPService()
    }
}

public extension SwiftyPressModule {
    
    func component() -> LogProviderType {
        LogProvider(stores: component())
    }
}

public extension SwiftyPressModule {
    
    func component() -> NotificationCenter {
        .default
    }
    
    func component() -> FileManager {
        .default
    }
    
    func component() -> JSONDecoder {
        .default
    }
}

public extension SwiftyPressModule {
    
    @available(iOS 10.0, *)
    func component(delegate: MailComposerDelegate? = nil) -> MailComposerType {
        let theme: Theme = component()
        
        return MailComposer(
            delegate: delegate,
            styleNavigationBar: {
                $0.tintColor = theme.tint
            }
        )
    }
}
