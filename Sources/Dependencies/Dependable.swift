//
//  Dependable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

public protocol Dependable {
    func resolveWorker() -> PostsWorkerType
    func resolveWorker() -> TaxonomyWorkerType
    func resolveWorker() -> AuthorsWorkerType
    func resolveWorker() -> MediaWorkerType
    func resolveWorker() -> SeedWorkerType
    
    func resolveStore() -> PostsStore
    func resolveStore() -> TaxonomyStore
    func resolveStore() -> AuthorsStore
    func resolveStore() -> MediaStore
    func resolveStore() -> SeedStore
    
    func resolveService() -> HTTPServiceType
    
    func resolveWorker() -> ConstantsType
    func resolve() -> PreferencesType
    func resolveStore() -> ConstantsStore
    func resolveStore() -> PreferencesStore
}
