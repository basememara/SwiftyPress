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
    
    func fetch(id: Int, completion: @escaping (Result<ExtendedPostType, DataError>) -> Void) {
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
                    // Type used for decoding the server payload
                    struct PayloadType: Decodable {
                        let post: Post
                        let author: Author?
                        let media: Media?
                        let categories: [Term]
                        let tags: [Term]
                    }
                    
                    // Parse response data
                    let payload = try JSONDecoder.default.decode(PayloadType.self, from: value.data)
                    
                    let model = ExtendedPostType(
                        post: payload.post,
                        author: payload.author,
                        media: payload.media,
                        categories: payload.categories,
                        tags: payload.tags
                    )
                    
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                } catch {
                    self.Log(error: "An error occured while parsing the post: \(error).")
                    return DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                }
            }
        }
    }
}
