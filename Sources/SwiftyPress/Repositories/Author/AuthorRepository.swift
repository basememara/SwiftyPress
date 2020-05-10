//
//  AuthorRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

public struct AuthorRepository {
    private let service: AuthorService
    private let cache: AuthorCache
    private let log: LogRepository
    
    public init(service: AuthorService, cache: AuthorCache, log: LogRepository) {
        self.service = service
        self.cache = cache
        self.log = log
    }
}

public extension AuthorRepository {
    
    func fetch(id: Int, completion: @escaping (Result<Author, SwiftyPressError>) -> Void) {
        cache.fetch(id: id) {
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = $0.error {
                self.service.fetch(id: id) {
                    guard case .success(let value) = $0 else {
                        completion($0)
                        return
                    }
                    
                    self.cache.createOrUpdate(value, completion: completion)
                }
                
                return
            }
            
            // Immediately return local response
            completion($0)
            
            guard case .success(let cacheElement) = $0 else { return }
            
            // Sync remote updates to cache if applicable
            self.service.fetch(id: id) {
                // Validate if any updates occurred and return
                guard case .success(let element) = $0,
                    element.modifiedAt > cacheElement.modifiedAt else {
                        return
                }
                
                // Update local storage with updated data
                self.cache.createOrUpdate(element) {
                    guard case .success = $0 else {
                        self.log.error("Could not save updated author locally from remote storage: \(String(describing: $0.error))")
                        return
                    }
                    
                    // Callback handler again if updated
                    completion($0)
                }
            }
        }
    }
}
