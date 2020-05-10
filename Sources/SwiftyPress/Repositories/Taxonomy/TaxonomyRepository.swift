//
//  TaxonomyRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL

public struct TaxonomyRepository {
    private let cache: TaxonomyCache
    private let dataRepository: DataRepository
    
    public init(cache: TaxonomyCache, dataRepository: DataRepository) {
        self.cache = cache
        self.dataRepository = dataRepository
    }
}

public extension TaxonomyRepository {
    
    func fetch(id: Int, completion: @escaping (Result<Term, SwiftyPressError>) -> Void) {
        cache.fetch(id: id) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataRepository.fetch {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { $0.id == id }) else {
                        completion(result)
                        return
                    }

                    self.cache.fetch(id: id, completion: completion)
                }

                return
            }
       
            completion(result)
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<Term, SwiftyPressError>) -> Void) {
        cache.fetch(slug: slug) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataRepository.fetch {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { $0.slug == slug }) else {
                        completion(result)
                        return
                    }

                    self.cache.fetch(slug: slug, completion: completion)
                }

                return
            }

            completion(result)
         }
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Term], SwiftyPressError>) -> Void) {
        cache.fetch(ids: ids) { result in
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = result.error {
                // Sync remote updates to cache if applicable
                self.dataRepository.fetch {
                    // Validate if any updates that needs to be stored
                    guard case .success(let value) = $0, value.terms.contains(where: { ids.contains($0.id) }) else {
                        completion(result)
                        return
                    }

                    self.cache.fetch(ids: ids, completion: completion)
                }

                return
            }

            completion(result)
        }
    }
}

public extension TaxonomyRepository {
    
    func fetch(completion: @escaping (Result<[Term], SwiftyPressError>) -> Void) {
        cache.fetch {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.fetch {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0, !value.terms.isEmpty else {
                    return
                }
                
                self.cache.fetch(completion: completion)
            }
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[Term], SwiftyPressError>) -> Void) {
        cache.fetch(by: taxonomy) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.fetch {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    value.terms.contains(where: { $0.taxonomy == taxonomy }) else {
                        return
                }
                
                self.cache.fetch(by: taxonomy, completion: completion)
            }
        }
    }
    
    func fetch(by taxonomies: [Taxonomy], completion: @escaping (Result<[Term], SwiftyPressError>) -> Void) {
        cache.fetch(by: taxonomies) {
            // Immediately return local response
            completion($0)
            
            guard case .success = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.dataRepository.fetch {
                // Validate if any updates that needs to be stored
                guard case .success(let value) = $0,
                    value.terms.contains(where: { taxonomies.contains($0.taxonomy) }) else {
                        return
                }
                
                self.cache.fetch(by: taxonomies, completion: completion)
            }
        }
    }
}

public extension TaxonomyRepository {
    
    func fetch(url: String, completion: @escaping (Result<Term, SwiftyPressError>) -> Void) {
        guard let slug = slug(from: url) else {
            completion(.failure(.nonExistent))
            return
        }
        
        fetch(slug: slug, completion: completion)
    }
}

public extension TaxonomyRepository {
    
    func getID(bySlug slug: String) -> Int? {
        cache.getID(bySlug: slug)
    }
    
    func getID(byURL url: String) -> Int? {
        guard let slug = slug(from: url) else { return nil }
        return getID(bySlug: slug)
    }
}

// MARK: - Helpers

private extension TaxonomyRepository {
    
    func slug(from url: String) -> String? {
        guard let url = URL(string: url) else { return nil }
        
        let slug = url.lastPathComponent.lowercased()
        let relativePath = url.relativePath
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()
        
        return relativePath.hasPrefix("category/") || relativePath .hasPrefix("tag/")
            ? slug : nil
    }
}
