//
//  MediaFileCache.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct MediaFileCache: MediaCache {
    private let seedService: SeedService
    
    init(seedService: SeedService) {
        self.seedService = seedService
    }
}

public extension MediaFileCache {
    
    func fetch(id: Int, completion: @escaping (Result<Media, SwiftyPressError>) -> Void) {
        seedService.fetch {
            guard case .success(let value) = $0 else {
                completion(.failure($0.error ?? .unknownReason(nil)))
                return
            }
            
            // Find match
            guard let model = value.media.first(where: { $0.id == id }) else {
                completion(.failure(.nonExistent))
                return
            }
            
            completion(.success(model))
        }
    }
}

public extension MediaFileCache {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Media], SwiftyPressError>) -> Void) {
        seedService.fetch {
            guard case .success(let value) = $0 else {
                completion(.failure($0.error ?? .unknownReason(nil)))
                return
            }
            
            let model = ids.reduce(into: [Media]()) { result, next in
                guard let element = value.media.first(where: { $0.id == next }) else { return }
                result.append(element)
            }
            
            completion(.success(model))
        }
    }
}

public extension MediaFileCache {
    
    func createOrUpdate(_ request: Media, completion: @escaping (Result<Media, SwiftyPressError>) -> Void) {
        // Nothing to do
    }
}
