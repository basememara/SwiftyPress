//
//  TaxonomyStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public struct TaxonomyWorker: TaxonomyWorkerType {
    private let store: TaxonomyStore
    
    public init(store: TaxonomyStore) {
        self.store = store
    }
}

public extension TaxonomyWorker {
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch(completion: completion)
    }
    
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void) {
        store.fetch(id: id, completion: completion)
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch(ids: ids, completion: completion)
    }
    
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        store.fetch(slug: slug, completion: completion)
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch(by: taxonomy, completion: completion)
    }
    
    func search(with request: TaxonomyModels.SearchRequest, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.search(with: request, completion: completion)
    }
}
