//
//  Dependency.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import Foundation

open class Dependency: Dependable {
    public init() { }
    
    // MARK: - Workers

    open func resolveWorker() -> PostsWorkerType {
        return PostsWorker(
            store: resolveStore(),
            preferences: resolve()
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
    
    open func resolveWorker() -> SeedWorkerType {
        return SeedWorker(store: resolveStore())
    }
    
    // MARK: - Store
    
    open func resolveStore() -> PostsStore {
        return PostsFileStore(
            store: resolveStore(),
            preferences: resolve()
        )
    }
    
    open func resolveStore() -> TaxonomyStore {
        return TaxonomyFileStore(store: resolveStore())
    }
    
    open func resolveStore() -> AuthorsStore {
        return AuthorsFileStore(store: resolveStore())
    }
    
    open func resolveStore() -> MediaStore {
        return MediaFileStore(store: resolveStore())
    }
    
    open func resolveStore() -> SeedStore {
        return SeedFileStore()
    }
    
    // MARK: - Service
    
    open func resolveService() -> HTTPServiceType {
        return HTTPService()
    }
    
    open func resolveService() -> APISessionType {
        return APISession(constants: resolve())
    }
    
    // MARK: - Preferences
    
    open func resolve() -> NotificationCenter {
        return .default
    }
    
    open func resolve() -> ConstantsType {
        return Constants(store: resolveStore())
    }
    
    open func resolve() -> PreferencesType {
        return Preferences(store: resolveStore())
    }
    
    open func resolve() -> Theme {
        fatalError("Override dependency in subclass")
    }
    
    open func resolveStore() -> ConstantsStore {
        fatalError("Override dependency in subclass")
    }
    
    open func resolveStore() -> PreferencesStore {
        fatalError("Override dependency in subclass")
    }
}
