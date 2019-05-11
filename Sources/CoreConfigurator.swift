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
            seedStore: resolveStore(),
            syncStore: resolveStore(),
            cacheStore: resolveStore()
        )
    }
    
    open func resolveStore() -> SeedStore {
        fatalError("Override dependency in app")
    }
    
    open func resolveStore() -> SyncStore {
        return SyncNetworkStore(apiSession: resolve())
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
        return AuthorWorker(store: resolveStore())
    }
    
    open func resolveStore() -> AuthorStore {
        return AuthorRealmStore()
    }
    
    open func resolve() -> MediaWorkerType {
        return MediaWorker(store: resolveStore())
    }
    
    open func resolveStore() -> MediaStore {
        return MediaRealmStore()
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
        fatalError("Override dependency in app")
    }
}
