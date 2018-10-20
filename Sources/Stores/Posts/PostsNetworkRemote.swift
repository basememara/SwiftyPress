//
//  PostsNetworkStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-10.
//

import ZamzamKit

public struct PostsNetworkRemote: PostsRemote, Loggable {
    private let apiSession: APISessionType
    
    public init(apiSession: APISessionType) {
        self.apiSession = apiSession
    }
}

public extension PostsNetworkRemote {
    
    func fetch(id: Int, completion: @escaping (Result<PostPayloadType, DataError>) -> Void) {
        apiSession.request(APIRouter.readPost(id: id)) {
            // Handle errors
            guard $0.isSuccess else {
                self.Log(error: "An error occured while fetching the post: \(String(describing: $0.error)).")
                return completion(.failure(DataError(from: $0.error)))
            }
            
            // Ensure available
            guard let value = $0.value else {
                return completion(.failure(.nonExistent))
            }
            
            DispatchQueue.transform.async {
                do {
                    // Parse response data
                    let payload = try JSONDecoder.default.decode(PostPayload.self, from: value.data)
                    DispatchQueue.main.async { completion(.success(PostPayloadType(from: payload))) }
                } catch {
                    self.Log(error: "An error occured while parsing the post: \(error).")
                    return DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                }
            }
        }
    }
}
