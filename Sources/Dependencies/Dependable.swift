//
//  Dependable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import Foundation

public protocol Dependable {
    func resolve() -> ConstantsType
    func resolve() -> PreferencesType
    func resolve() -> NotificationCenter
    func resolve() -> Theme
    
    func resolveWorker() -> DataWorkerType
    func resolveWorker() -> PostsWorkerType
    func resolveWorker() -> TaxonomyWorkerType
    func resolveWorker() -> AuthorsWorkerType
    func resolveWorker() -> MediaWorkerType
    
    func resolveStore() -> ConstantsStore
    func resolveStore() -> PreferencesStore
    
    func resolveStore() -> SeedStore
    func resolveStore() -> SyncStore
    func resolveStore() -> CacheStore
    
    func resolveStore() -> PostsStore
    func resolveStore() -> TaxonomyStore
    func resolveStore() -> AuthorsStore
    func resolveStore() -> MediaStore
    
    func resolveRemote() -> PostsRemote
    
    func resolveService() -> HTTPServiceType
    func resolveService() -> APISessionType
}
