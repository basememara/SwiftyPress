//
//  SeedFileStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public struct SeedFileStore: SeedStore {
    
}

public extension SeedFileStore {
    private static var cachedPayload: ModifiedPayload?
    
    func fetchModified(after date: Date?, completion: @escaping (Result<ModifiedPayload, DataError>) -> Void) {
        // Populate cache if applicable
        if SeedFileStore.cachedPayload == nil {
            do {
                SeedFileStore.cachedPayload = try JSONDecoder.default.decode(
                    ModifiedPayload.self,
                    forResource: "modified_payload.json",
                    inBundle: .swiftyPress
                )
            } catch {
                completion(.failure(.databaseFailure(error)))
                // TODO: Log(error: "An error occured while parsing the offline modified payload: \(String(describing: error)).")
                return
            }
        }
        
        guard let payload = SeedFileStore.cachedPayload else {
            return completion(.failure(.nonExistent))
        }
        
        // Return all elements if applicable
        guard let date = date else { return completion(.success(payload)) }
        
        // Filter for elements that have been modified by requested date
        let modifiedPayload = ModifiedPayload(
            posts: payload.posts.filter { $0.modifiedAt > date },
            categories: payload.categories,
            tags: payload.tags,
            authors: payload.authors.filter { $0.modifiedAt > date },
            media: payload.media
        )
        
        completion(.success(modifiedPayload))
    }
}
