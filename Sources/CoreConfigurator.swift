//
//  SwiftyPressConfigurator.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

open class CoreConfigurator: CoreDependable {
    public init() {}
    
    open func resolve() -> ConstantsType {
        return Constants(store: resolveStore())
    }
    
    open func resolveStore() -> ConstantsStore {
        fatalError("Override dependency in app")
    }
    
    open func resolve() -> PreferencesType {
        return Preferences(store: resolveStore())
    }
    
    open func resolveStore() -> PreferencesStore {
        fatalError("Override dependency in app")
    }
    
    // MARK: - Workers
    
    open func resolve() -> DataWorkerType {
        return DataWorker(
            constants: resolve(),
            seedStore: resolveStore(),
            remoteStore: resolveStore(),
            cacheStore: resolveStore()
        )
    }
    
    open func resolveStore() -> SeedStore {
        fatalError("Override dependency in app")
    }
    
    open func resolveStore() -> RemoteStore {
        return RemoteNetworkStore(apiSession: resolve())
    }
    
    open func resolveStore() -> CacheStore {
        return CacheRealmStore(preferences: resolve())
    }
    
    open func resolve() -> PostWorkerType {
        return PostWorker(
            store: resolveStore(),
            remote: resolveRemote(),
            preferences: resolve(),
            constants: resolve(),
            dataWorker: resolve()
        )
    }
    
    open func resolveStore() -> PostStore {
        return PostRealmStore()
    }
    
    open func resolveRemote() -> PostRemote {
        return PostNetworkRemote(apiSession: resolve())
    }
    
    open func resolve() -> AuthorWorkerType {
        return AuthorWorker(
            store: resolveStore(),
            remote: resolveRemote()
        )
    }
    
    open func resolveStore() -> AuthorStore {
        return AuthorRealmStore()
    }
    
    open func resolveRemote() -> AuthorRemote {
        return AuthorNetworkRemote(apiSession: resolve())
    }
    
    open func resolve() -> MediaWorkerType {
        return MediaWorker(
            store: resolveStore(),
            remote: resolveRemote()
        )
    }
    
    open func resolveStore() -> MediaStore {
        return MediaRealmStore()
    }
    
    open func resolveRemote() -> MediaRemote {
        return MediaNetworkRemote(apiSession: resolve())
    }
    
    open func resolve() -> TaxonomyWorkerType {
        return TaxonomyWorker(
            store: resolveStore(),
            dataWorker: resolve()
        )
    }
    
    open func resolveStore() -> TaxonomyStore {
        return TaxonomyRealmStore()
    }
    
    open func resolve() -> NotificationCenter {
        return .default
    }
    
    open func resolve() -> APISessionType {
        return APISession(constants: resolve())
    }
    
    open func resolve() -> HTTPServiceType {
        return HTTPService()
    }
    
    open func resolve() -> Theme {
        return SwiftyTheme()
    }
    
    #if os(iOS)
    open func resolve(delegate: MailComposerDelegate?) -> MailComposerType {
        let theme: Theme = resolve()
        
        return MailComposer(
            delegate: delegate,
            styleNavigationBar: {
                $0.tintColor = theme.tint
            }
        )
    }
    #endif
}
