//
//  MediaStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct MediaWorker: MediaWorkerType {
    private let store: MediaStore
    private let remote: MediaRemote?
    
    public init(store: MediaStore, remote: MediaRemote?) {
        self.store = store
        self.remote = remote
    }
}

public extension MediaWorker {
    
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void) {
        store.fetch(id: id) {
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
                    
                    self.store.createOrUpdate(value, completion: completion)
                }
                
                return
            }
            
            // Immediately return local response
            completion($0)
        }
    }
}

public extension MediaWorker {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[MediaType], DataError>) -> Void) {
        store.fetch(ids: ids, completion: completion)
    }
}
