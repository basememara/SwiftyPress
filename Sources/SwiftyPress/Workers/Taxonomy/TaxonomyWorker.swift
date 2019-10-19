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
        store.fetch(id: id) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataWorker.pull {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { $0.id == id }) else {
                        completion(result)
                        return
                    }

                    self.store.fetch(id: id, completion: completion)
                }

                return
            }
       
            completion(result)
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        store.fetch(slug: slug) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataWorker.pull {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { $0.slug == slug }) else {
                        completion(result)
                        return
                    }

                    self.store.fetch(slug: slug, completion: completion)
                }

                return
            }

            completion(result)
         }
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch(ids: ids) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataWorker.pull {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { ids.contains($0.id) }) else {
                        completion(result)
                        return
                    }

                    self.store.fetch(ids: ids, completion: completion)
                }

                return
            }

            completion(result)
        }
    }
}

public extension TaxonomyWorker {
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0, !value.terms.isEmpty else {
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
            self.dataWorker.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    value.terms.contains(where: { $0.taxonomy == taxonomy }) else {
                        return
                }
                
                self.store.fetch(by: taxonomy, completion: completion)
            }
        }
    }
    
    func fetch(by taxonomies: [Taxonomy], completion: @escaping (Result<[TermType], DataError>) -> Void) {
        store.fetch(by: taxonomies) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataWorker.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    value.terms.contains(where: { taxonomies.contains($0.taxonomy) }) else {
                        return
                }
                
                self.store.fetch(by: taxonomies, completion: completion)
            }
        }
    }
}

public extension TaxonomyWorker {
    
    func getID(bySlug slug: String) -> Int? {
        store.getID(bySlug: slug)
    }
}
