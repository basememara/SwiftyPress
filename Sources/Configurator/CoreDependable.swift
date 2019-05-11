//
//  DependencyFactory.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

public protocol CoreDependable {
    func resolve() -> ConstantsType
    func resolveStore() -> ConstantsStore
    
    func resolve() -> PreferencesType
    func resolveStore() -> PreferencesStore
    
    func resolve() -> DataWorkerType
    func resolveStore() -> SeedStore
    func resolveStore() -> SyncStore
    func resolveStore() -> CacheStore
    
    func resolve() -> PostWorkerType
    func resolveStore() -> PostStore
    func resolveRemote() -> PostRemote
    
    func resolve() -> AuthorWorkerType
    func resolveStore() -> AuthorStore
    
    func resolve() -> MediaWorkerType
    func resolveStore() -> MediaStore
    
    func resolve() -> TaxonomyWorkerType
    func resolveStore() -> TaxonomyStore
    
    func resolve() -> NotificationCenter
    func resolve() -> APISessionType
    func resolve() -> HTTPServiceType
    func resolve() -> Theme
}
