//
//  PostsNetworkStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-10.
//

import Foundation

public struct PostNetworkRemote: PostRemote, Loggable {
    private let apiSession: APISessionType
    
    public init(apiSession: APISessionType) {
        self.apiSession = apiSession
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
                
                self.Log(error: "An error occured while fetching the post: \(String(describing: $0.error)).")
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
                    self.Log(error: "An error occured while parsing the post: \(error).")
                    DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                    return
                }
            }
        }
    }
}
