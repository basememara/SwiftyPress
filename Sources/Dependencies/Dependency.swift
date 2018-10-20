//
//  Dependency.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import Foundation

open class Dependency: Dependable {
    public init() { }
    
    // MARK: - Preferences
    
    open func resolve() -> ConstantsType {
        return Constants(store: resolveStore())
    }
    
    open func resolve() -> PreferencesType {
        return Preferences(store: resolveStore())
    }
    
    open func resolve() -> NotificationCenter {
        return .default
    }
    
    open func resolve() -> Theme {
        fatalError("Override dependency in subclass")
    }
    
    // MARK: - Workers
    
    open func resolveWorker() -> DataWorkerType {
        return DataWorker(
            seedStore: resolveStore(),
            syncStore: resolveStore(),
            cacheStore: resolveStore()
        )
    }

    open func resolveWorker() -> PostsWorkerType {
        return PostsWorker(
            store: resolveStore(),
            remote: resolveRemote(),
            preferences: resolve(),
            constants: resolve(),
            dataWorker: resolveWorker()
        )
    }
    
    open func resolveWorker() -> TaxonomyWorkerType {
        return TaxonomyWorker(store: resolveStore())
    }
    
    open func resolveWorker() -> AuthorsWorkerType {
        return AuthorsWorker(store: resolveStore())
    }
    
    open func resolveWorker() -> MediaWorkerType {
        return MediaWorker(store: resolveStore())
    }
    
    // MARK: - Store
    
    open func resolveStore() -> ConstantsStore {
        fatalError("Override dependency in subclass")
    }
    
    open func resolveStore() -> PreferencesStore {
        fatalError("Override dependency in subclass")
    }
    
    open func resolveStore() -> SeedStore {
        fatalError("Override dependency in subclass")
    }
    
    open func resolveStore() -> SyncStore {
        return SyncNetworkStore(apiSession: resolveService())
    }
    
    open func resolveStore() -> CacheStore {
        return CacheRealmStore(preferences: resolve())
    }
    
    open func resolveStore() -> PostsStore {
        return PostsRealmStore()
    }
    
    open func resolveStore() -> TaxonomyStore {
        return TaxonomyFileStore(seedStore: resolveStore())
    }
    
    open func resolveStore() -> AuthorsStore {
        return AuthorsFileStore(seedStore: resolveStore())
    }
    
    open func resolveStore() -> MediaStore {
        return MediaFileStore(seedStore: resolveStore())
    }

    // MARK: - Remote

    open func resolveRemote() -> PostsRemote {
        return PostsNetworkRemote(apiSession: resolveService())
    }
    
    // MARK: - Service
    
    open func resolveService() -> HTTPServiceType {
        return HTTPService()
    }
    
    open func resolveService() -> APISessionType {
        return APISession(constants: resolve())
    }
}
