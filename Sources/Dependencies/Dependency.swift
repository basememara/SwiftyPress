//
//  Dependency.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

open class Dependency: Dependable {
    public init() { }
    
    // MARK: - Workers

    open func resolveWorker() -> PostsWorkerType {
        return PostsWorker(store: resolveStore())
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
        return PostsFileStore(store: resolveStore())
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
}
