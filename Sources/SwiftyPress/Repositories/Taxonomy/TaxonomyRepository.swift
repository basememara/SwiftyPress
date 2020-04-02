//
//  TaxonomyRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct TaxonomyRepository: TaxonomyRepositoryType {
    private let service: TaxonomyService
    private let dataRepository: DataRepositoryType
    
    public init(service: TaxonomyService, dataRepository: DataRepositoryType) {
        self.service = service
        self.dataRepository = dataRepository
    }
}

public extension TaxonomyRepository {
    
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void) {
        service.fetch(id: id) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataRepository.pull {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { $0.id == id }) else {
                        completion(result)
                        return
                    }

                    self.service.fetch(id: id, completion: completion)
                }

                return
            }
       
            completion(result)
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        service.fetch(slug: slug) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataRepository.pull {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { $0.slug == slug }) else {
                        completion(result)
                        return
                    }

                    self.service.fetch(slug: slug, completion: completion)
                }

                return
            }

            completion(result)
         }
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        service.fetch(ids: ids) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataRepository.pull {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { ids.contains($0.id) }) else {
                        completion(result)
                        return
                    }

                    self.service.fetch(ids: ids, completion: completion)
                }

                return
            }

            completion(result)
        }
    }
}

public extension TaxonomyRepository {
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        service.fetch {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0, !value.terms.isEmpty else {
                    return
                }
                
                self.service.fetch(completion: completion)
            }
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        service.fetch(by: taxonomy) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    value.terms.contains(where: { $0.taxonomy == taxonomy }) else {
                        return
                }
                
                self.service.fetch(by: taxonomy, completion: completion)
            }
        }
    }
    
    func fetch(by taxonomies: [Taxonomy], completion: @escaping (Result<[TermType], DataError>) -> Void) {
        service.fetch(by: taxonomies) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.pull {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    value.terms.contains(where: { taxonomies.contains($0.taxonomy) }) else {
                        return
                }
                
                self.service.fetch(by: taxonomies, completion: completion)
            }
        }
    }
}

public extension TaxonomyRepository {
    
    func getID(bySlug slug: String) -> Int? {
        service.getID(bySlug: slug)
    }
}
