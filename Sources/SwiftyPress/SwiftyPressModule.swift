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
    
    func component() -> DataWorkerType
    func componentStore() -> SeedStore
    func componentStore() -> RemoteStore
    func componentStore() -> CacheStore
    
    func component() -> PostWorkerType
    func componentStore() -> PostStore
    func componentRemote() -> PostRemote
    
    func component() -> AuthorWorkerType
    func componentStore() -> AuthorStore
    
    func component() -> MediaWorkerType
    func componentStore() -> MediaStore
    
    func component() -> TaxonomyWorkerType
    func componentStore() -> TaxonomyStore
    
    func component() -> APISessionType
    func component() -> HTTPServiceType
    
    func component() -> LogWorkerType
    func componentStores() -> [LogStore]
    
    func component() -> NotificationCenter
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
    
    func component() -> DataWorkerType {
        DataWorker(
            constants: component(),
            seedStore: componentStore(),
            remoteStore: componentStore(),
            cacheStore: componentStore(),
            log: component()
        )
    }
    
    func componentStore() -> RemoteStore {
        RemoteNetworkStore(
            apiSession: component(),
            log: component()
        )
    }
    
    func componentStore() -> CacheStore {
        CacheRealmStore(
            preferences: component(),
            log: component()
        )
    }
}

public extension SwiftyPressModule {
    
    func component() -> PostWorkerType {
        PostWorker(
            store: componentStore(),
            remote: componentRemote(),
            preferences: component(),
            constants: component(),
            dataWorker: component(),
            log: component()
        )
    }
    
    func componentStore() -> PostStore {
        PostRealmStore(log: component())
    }
    
    func componentRemote() -> PostRemote {
        PostNetworkRemote(
            apiSession: component(),
            log: component()
        )
    }
}

public extension SwiftyPressModule {
    
    func component() -> AuthorWorkerType {
        AuthorWorker(
            store: componentStore(),
            remote: componentRemote(),
            log: component()
        )
    }
    
    func componentStore() -> AuthorStore {
        AuthorRealmStore()
    }
    
    func componentRemote() -> AuthorRemote {
        AuthorNetworkRemote(
            apiSession: component(),
            log: component()
        )
    }
}

public extension SwiftyPressModule {
    
    func component() -> MediaWorkerType {
        MediaWorker(
            store: componentStore(),
            remote: componentRemote()
        )
    }
    
    func componentStore() -> MediaStore {
        MediaRealmStore(log: component())
    }
    
    func componentRemote() -> MediaRemote {
        MediaNetworkRemote(
            apiSession: component(),
            log: component()
        )
    }
}

public extension SwiftyPressModule {
    
    func component() -> TaxonomyWorkerType {
        TaxonomyWorker(
            store: componentStore(),
            dataWorker: component()
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
    
    func component() -> LogWorkerType {
        LogWorker(stores: componentStores())
    }
    
    func componentStores() -> [LogStore] {
        let constants: ConstantsType = component()
        
        return [
            LogConsoleStore(minLevel: constants.minLogLevel)
        ]
    }
}

public extension SwiftyPressModule {
    
    func component() -> NotificationCenter {
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
