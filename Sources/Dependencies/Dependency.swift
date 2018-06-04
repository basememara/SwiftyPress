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
    
    // MARK: - Store
    
    open func resolveStore() -> PostsStore {
        return PostsMemoryStore()
    }
    
    open func resolveStore() -> TaxonomyStore {
        return TaxonomyMemoryStore()
    }
    
    open func resolveStore() -> AuthorsStore {
        return AuthorsMemoryStore()
    }
    
    open func resolveStore() -> MediaStore {
        return MediaMemoryStore()
    }
}
