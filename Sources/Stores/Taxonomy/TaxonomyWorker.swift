//
//  TaxonomyStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

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
            
            guard $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard ($0.value?.categories.isEmpty == false || $0.value?.tags.isEmpty == false), $0.isSuccess else { return }
                self.store.fetch(completion: completion)
            }
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch(by: taxonomy) {
            // Immediately return local response
            completion($0)
            
            guard $0.isSuccess else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.sync {
                // Validate if any updates that needs to be stored
                guard taxonomy == .category
                    ? $0.value?.categories.isEmpty == false
                    : $0.value?.tags.isEmpty == false,
                    $0.isSuccess else {
                        return
                }
                
                self.store.fetch(by: taxonomy, completion: completion)
            }
        }
    }
}
