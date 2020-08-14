//
//  DataNetworkService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct DataNetworkService: DataService {
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

public extension DataNetworkService {
    
    func fetchModified(
        after date: Date?,
        with request: DataAPI.ModifiedRequest,
        completion: @escaping (Result<SeedPayload, SwiftyPressError>) -> Void
    ) {
        let urlRequest: URLRequest = .modified(after: date, with: request, constants: constants)
        
        networkRepository.send(with: urlRequest) {
            guard case .success(let item) = $0 else {
                // Handle no modified data and return success
                if $0.error?.statusCode == 304 {
                    completion(.success(SeedPayload()))
                    return
                }
                
                self.log.error("An error occured while fetching the modified payload: \(String(describing: $0.error)).")
                completion(.failure(SwiftyPressError(from: $0.error ?? .init(request: urlRequest))))
                return
            }
            
            guard let data = item.data else {
                completion(.failure(.nonExistent))
                return
            }
            
            DispatchQueue.transform.async {
                do {
                    // Parse response data
                    let payload = try self.jsonDecoder.decode(SeedPayload.self, from: data)
                    DispatchQueue.main.async { completion(.success(payload)) }
                } catch {
                    self.log.error("An error occured while parsing the modified payload: \(error).")
                    DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                    return
                }
            }
        }
    }
}

// MARK: - Requests

private extension URLRequest {
    
    static func modified(after: Date?, with request: DataAPI.ModifiedRequest, constants: Constants) -> URLRequest {
        URLRequest(
            url: constants.baseURL
                .appendingPathComponent(constants.baseREST)
                .appendingPathComponent("modified"),
            method: .get,
            parameters: {
                var params: [String: Any] = [:]
                
                if let timestamp = after?.timeIntervalSince1970 {
                    params["after"] = Int(timestamp)
                }
                
                if !request.taxonomies.isEmpty {
                    params["taxonomies"] = request.taxonomies
                        .joined(separator: ",")
                }
                
                if !request.postMetaKeys.isEmpty {
                    params["meta_keys"] = request.postMetaKeys
                        .joined(separator: ",")
                }
                
                if let limit = request.limit {
                    params["limit"] = limit
                }
                
                return params
            }(),
            timeoutInterval: 30
        )
    }
}

