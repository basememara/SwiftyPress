//
//  HTTPService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-17.
//

import Alamofire
import ZamzamKit

public typealias ServerResponse = (data: Data, headers: [String: String], statusCode: Int)

public protocol HTTPServiceType {
    func post(url: String, parameters: [String: Any], headers: [String: String]?, completion: @escaping (Swift.Result<ServerResponse, NetworkError>) -> Void)
}

public struct HTTPService: HTTPServiceType {
    private let sessionManager: SessionManager
    
    init() {
        let configuration = URLSessionConfiguration.default
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
}

public extension HTTPService {
    
    func post(url: String, parameters: [String: Any], headers: [String: String]? = nil, completion: @escaping (Swift.Result<ServerResponse, NetworkError>) -> Void) {
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        do {
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        } catch {
            return completion(.failure(
                NetworkError(urlRequest: urlRequest, statusCode: 0, internalError: error)
            ))
        }
        
        headers?.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        sessionManager.request(urlRequest, completion: completion)
    }
}

// MARK: - HTTP library helper

public extension SessionManager {
    
    /// Creates a network request to retrieve the contents of a URL based on the specified urlRequest.
    ///
    /// - Parameters:
    ///   - urlRequest: The URL request.
    ///   - completion: A handler to be called once the request has finished.
    func request(_ urlRequest: URLRequest, completion: @escaping (Swift.Result<ServerResponse, NetworkError>) -> Void) {
        request(urlRequest)
            .validate()
            .responseData {
                let statusCode = $0.response?.statusCode ?? 0
                let headers: [String: String] = {
                    guard let allHeaderFields = $0 else { return [:] }
                    return Dictionary(uniqueKeysWithValues: allHeaderFields.map {("\($0)", "\($1)")})
                }($0.response?.allHeaderFields)
                
                // Handle errors
                guard let value = $0.result.value, $0.result.isSuccess else {
                    let error = NetworkError(
                        urlRequest: $0.request,
                        statusCode: statusCode,
                        headerValues: headers,
                        serverData: $0.data,
                        internalError: $0.error
                    )
                    
                    return completion(.failure(error))
                }
                
                completion(.success((value, headers, statusCode)))
        }
    }
}
