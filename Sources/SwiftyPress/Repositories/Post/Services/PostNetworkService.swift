//
//  PostsNetworkService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-10.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct PostNetworkService: PostService {
    private let networkRepository: NetworkRepository
    private let jsonDecoder: JSONDecoder
    private let constants: Constants
    private let log: LogRepository
    
    public init(
        networkRepository: NetworkRepository,
        jsonDecoder: JSONDecoder,
        constants: Constants,
        log: LogRepository
    ) {
        self.networkRepository = networkRepository
        self.jsonDecoder = jsonDecoder
        self.constants = constants
        self.log = log
    }
}

public extension PostNetworkService {
    
    func fetch(id: Int, with request: PostAPI.ItemRequest, completion: @escaping (Result<ExtendedPost, SwiftyPressError>) -> Void) {
        let urlRequest: URLRequest = .readPost(id: id, with: request, constants: constants)
        
        networkRepository.send(with: urlRequest) {
            // Handle errors
            guard case .success = $0 else {
                // Handle no existing data
                if $0.error?.statusCode == 404 {
                    completion(.failure(.nonExistent))
                    return
                }
                
                self.log.error("An error occured while fetching the post: \(String(describing: $0.error)).")
                completion(.failure(SwiftyPressError(from: $0.error)))
                return
            }
            
            // Ensure available
            guard case .success(let item) = $0, let data = item.data else {
                completion(.failure(.nonExistent))
                return
            }
            
            DispatchQueue.transform.async {
                do {
                    // Parse response data
                    let payload = try self.jsonDecoder.decode(ExtendedPost.self, from: data)
                    
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

// MARK: - Requests

private extension URLRequest {
    
    static func readPost(id: Int, with request: PostAPI.ItemRequest, constants: Constants) -> URLRequest {
        URLRequest(
            url: constants.baseURL
                .appendingPathComponent(constants.baseREST)
                .appendingPathComponent("post/\(id)"),
            method: .get,
            parameters: {
                var params: [String: Any] = [:]
                
                if !request.taxonomies.isEmpty {
                    params["taxonomies"] = request.taxonomies
                        .joined(separator: ",")
                }
                
                if !request.postMetaKeys.isEmpty {
                    params["meta_keys"] = request.postMetaKeys
                        .joined(separator: ",")
                }
                
                return params
            }()
        )
    }
}
