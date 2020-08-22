//
//  MediaRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct MediaRepository {
    private let service: MediaService
    private let cache: MediaCache
    
    public init(service: MediaService, cache: MediaCache) {
        self.service = service
        self.cache = cache
    }
}

public extension MediaRepository {
    
    func fetch(id: Int, completion: @escaping (Result<Media, SwiftyPressError>) -> Void) {
        cache.fetch(id: id) {
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = $0.error {
                self.service.fetch(id: id) {
                    guard case let .success(item) = $0 else {
                        completion($0)
                        return
                    }
                    
                    self.cache.createOrUpdate(item, completion: completion)
                }
                
                return
            }
            
            // Immediately return local response
            completion($0)
        }
    }
}

public extension MediaRepository {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Media], SwiftyPressError>) -> Void) {
        cache.fetch(ids: ids, completion: completion)
    }
}
