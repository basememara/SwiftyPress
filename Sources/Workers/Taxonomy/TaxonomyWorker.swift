//
//  TaxonomyStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct TaxonomyWorker: TaxonomyWorkerType {
    private let store: TaxonomyStore
    private let dataWorker: DataWorkerType
    
    public init(store: TaxonomyStore, dataWorker: DataWorkerType) {
        self.store = store
        self.dataWorker = dataWorker
    }
}

public extension TaxonomyWorker {
    
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void) {
        store.fetch(id: id, completion: completion)
    }
    
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        store.fetch(slug: slug, completion: completion)
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch(ids: ids, completion: completion)
    }
}

public extension TaxonomyWorker {
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    !value.categories.isEmpty || !value.tags.isEmpty else {
                        return
                }
                
                self.store.fetch(completion: completion)
            }
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch(by: taxonomy) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    taxonomy == .category ? !value.categories.isEmpty : !value.tags.isEmpty else {
                        return
                }
                
                self.store.fetch(by: taxonomy, completion: completion)
            }
        }
    }
}

public extension TaxonomyWorker {
    
    func getID(bySlug slug: String) -> Int? {
        return store.getID(bySlug: slug)
    }
}
