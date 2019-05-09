//
//  DependencyFactory.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import Foundation

public protocol DependencyFactoryType {
    func resolve() -> ConstantsType
    func resolve() -> PreferencesType
    func resolve() -> NotificationCenter
    
    func resolveWorker() -> DataWorkerType
    func resolveWorker() -> PostWorkerType
    func resolveWorker() -> AuthorWorkerType
    func resolveWorker() -> MediaWorkerType
    func resolveWorker() -> TaxonomyWorkerType
    
    func resolveStore() -> ConstantsStore
    func resolveStore() -> PreferencesStore
    
    func resolveStore() -> SeedStore
    func resolveStore() -> SyncStore
    func resolveStore() -> CacheStore
    
    func resolveStore() -> PostStore
    func resolveStore() -> AuthorStore
    func resolveStore() -> MediaStore
    func resolveStore() -> TaxonomyStore
    
    func resolveRemote() -> PostRemote
    
    func resolveService() -> APISessionType
    func resolveService() -> HTTPServiceType
    
    func resolve() -> Theme
}

open class DependencyFactory: DependencyFactoryType {
    public init() { }
    
    // MARK: - Misc
    
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

    open func resolveWorker() -> PostWorkerType {
        return PostWorker(
            store: resolveStore(),
            remote: resolveRemote(),
            preferences: resolve(),
            constants: resolve(),
            dataWorker: resolveWorker()
        )
    }
    
    open func resolveWorker() -> AuthorWorkerType {
        return AuthorWorker(store: resolveStore())
    }
    
    open func resolveWorker() -> MediaWorkerType {
        return MediaWorker(store: resolveStore())
    }
    
    open func resolveWorker() -> TaxonomyWorkerType {
        return TaxonomyWorker(
            store: resolveStore(),
            dataWorker: resolveWorker()
        )
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
    
    open func resolveStore() -> PostStore {
        return PostRealmStore()
    }
    
    open func resolveStore() -> AuthorStore {
        return AuthorRealmStore()
    }
    
    open func resolveStore() -> MediaStore {
        return MediaRealmStore()
    }
    
    open func resolveStore() -> TaxonomyStore {
        return TaxonomyRealmStore()
    }

    // MARK: - Remote

    open func resolveRemote() -> PostRemote {
        return PostNetworkRemote(apiSession: resolveService())
    }
    
    // MARK: - Service
    
    open func resolveService() -> APISessionType {
        return APISession(constants: resolve())
    }
    
    open func resolveService() -> HTTPServiceType {
        return HTTPService()
    }
}
