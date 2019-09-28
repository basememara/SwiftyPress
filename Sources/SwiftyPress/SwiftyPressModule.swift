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
    
    func component() -> NotificationCenter
    func component() -> Theme
    
    @available(iOS 10.0, *)
    func component(delegate: MailComposerDelegate?) -> MailComposerType
}

public extension SwiftyPressModule {
    
    func component() -> ConstantsType {
        return Constants(store: componentStore())
    }
}

public extension SwiftyPressModule {
    
    func component() -> PreferencesType {
        return Preferences(store: componentStore())
    }
}

public extension SwiftyPressModule {
    
    func component() -> DataWorkerType {
        return DataWorker(
            constants: component(),
            seedStore: componentStore(),
            remoteStore: componentStore(),
            cacheStore: componentStore()
        )
    }
    
    func componentStore() -> RemoteStore {
        return RemoteNetworkStore(apiSession: component())
    }
    
    func componentStore() -> CacheStore {
        return CacheRealmStore(preferences: component())
    }
}

public extension SwiftyPressModule {
    
    func component() -> PostWorkerType {
        return PostWorker(
            store: componentStore(),
            remote: componentRemote(),
            preferences: component(),
            constants: component(),
            dataWorker: component()
        )
    }
    
    func componentStore() -> PostStore {
        return PostRealmStore()
    }
    
    func componentRemote() -> PostRemote {
        return PostNetworkRemote(apiSession: component())
    }
}

public extension SwiftyPressModule {
    
    func component() -> AuthorWorkerType {
        return AuthorWorker(
            store: componentStore(),
            remote: componentRemote()
        )
    }
    
    func componentStore() -> AuthorStore {
        return AuthorRealmStore()
    }
    
    func componentRemote() -> AuthorRemote {
        return AuthorNetworkRemote(apiSession: component())
    }
}

public extension SwiftyPressModule {
    
    func component() -> MediaWorkerType {
        return MediaWorker(
            store: componentStore(),
            remote: componentRemote()
        )
    }
    
    func componentStore() -> MediaStore {
        return MediaRealmStore()
    }
    
    func componentRemote() -> MediaRemote {
        return MediaNetworkRemote(apiSession: component())
    }
}

public extension SwiftyPressModule {
    
    func component() -> TaxonomyWorkerType {
        return TaxonomyWorker(
            store: componentStore(),
            dataWorker: component()
        )
    }
    
    func componentStore() -> TaxonomyStore {
        return TaxonomyRealmStore()
    }
}

public extension SwiftyPressModule {
    
    func component() -> APISessionType {
        return APISession(constants: component())
    }
    
    func component() -> HTTPServiceType {
        return HTTPService()
    }
}

public extension SwiftyPressModule {
    
    func component() -> NotificationCenter {
        return .default
    }
    
    func component() -> Theme {
        return SwiftyTheme()
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
