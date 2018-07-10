//
//  MediaStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public struct MediaWorker: MediaWorkerType {
    private let store: MediaStore
    
    public init(store: MediaStore) {
        self.store = store
    }
}

public extension MediaWorker {
    
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void) {
        store.fetch(id: id, completion: completion)
    }
}

public extension MediaWorker {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[MediaType], DataError>) -> Void) {
        store.fetch(ids: ids, completion: completion)
    }
}
