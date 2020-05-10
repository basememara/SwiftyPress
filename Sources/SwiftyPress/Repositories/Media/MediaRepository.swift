//
//  MediaRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct MediaRepository {
    private let service: MediaService
    private let remote: MediaRemote?
    
    public init(service: MediaService, remote: MediaRemote?) {
        self.service = service
        self.remote = remote
    }
}

public extension MediaRepository {
    
    func fetch(id: Int, completion: @escaping (Result<Media, SwiftyPressError>) -> Void) {
        service.fetch(id: id) {
            guard let remote = self.remote else {
                completion($0)
                return
            }
            
            // Retrieve missing cache data from cloud if applicable
            if case .nonExistent? = $0.error {
                remote.fetch(id: id) {
                    guard case .success(let value) = $0 else {
                        completion($0)
                        return
                    }
                    
                    self.service.createOrUpdate(value, completion: completion)
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
        service.fetch(ids: ids, completion: completion)
    }
}
