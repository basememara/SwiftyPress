//
//  PostsNetworkStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-10.
//

import Foundation
import ZamzamCore

public struct PostNetworkRemote: PostRemote {
    private let apiSession: APISessionType
    private let log: LogWorkerType
    
    public init(apiSession: APISessionType, log: LogWorkerType) {
        self.apiSession = apiSession
        self.log = log
    }
}

public extension PostNetworkRemote {
    
    func fetch(id: Int, with request: PostsAPI.ItemRequest, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void) {
        apiSession.request(APIRouter.readPost(id: id, request)) {
            // Handle errors
            guard case .success = $0 else {
                // Handle no existing data
                if $0.error?.statusCode == 404 {
                    completion(.failure(.nonExistent))
                    return
                }
                
                self.log.error("An error occured while fetching the post: \(String(describing: $0.error)).")
                completion(.failure(DataError(from: $0.error)))
                return
            }
            
            // Ensure available
            guard case .success(let value) = $0 else {
                completion(.failure(.nonExistent))
                return
            }
            
            DispatchQueue.transform.async {
                do {
                    // Parse response data
                    let payload = try JSONDecoder.default.decode(ExtendedPost.self, from: value.data)
                    
                    DispatchQueue.main.async {
                        completion(.success(payload))
                    }
                } catch {
                    self.log.error("An error occured while parsing the post: \(error).")
                    DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                    return
                }
            }
        }
    }
}
