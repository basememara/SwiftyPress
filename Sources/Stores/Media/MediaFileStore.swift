//
//  MediaMemoryStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import ZamzamKit

public struct MediaFileStore: MediaStore {
    private let seedStore: SeedStore
    
    init(seedStore: SeedStore) {
        self.seedStore = seedStore
    }
}

public extension MediaFileStore {
    
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void) {
        seedStore.fetch {
            guard let data = $0.value, $0.isSuccess else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            // Find match
            guard let value = data.media.first(where: { $0.id == id }) else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
}

public extension MediaFileStore {
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[MediaType], DataError>) -> Void) {
        seedStore.fetch {
            guard let data = $0.value, $0.isSuccess else {
                return completion(.failure($0.error ?? .unknownReason(nil)))
            }
            
            let value = ids.reduce(into: [MediaType]()) { result, next in
                guard let element = data.media.first(where: { $0.id == next }) else { return }
                result.append(element)
            }
            
            completion(.success(value))
        }
    }
}
