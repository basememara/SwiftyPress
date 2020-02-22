//
//  APISession.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Alamofire
import ZamzamCore

public protocol APISessionType {
    func request(_ route: APIRoutable, completion: @escaping (Result<NetworkAPI.Response, NetworkAPI.Error>) -> Void)
}

public struct APISession: APISessionType {
    private let session: Session
    private let constants: ConstantsType
    private let log: LogProviderType
    
    public init(constants: ConstantsType, log: LogProviderType) {
        self.session = .init(configuration: .default)
        self.constants = constants
        self.log = log
    }
}

public extension APISession {
    
    /// Creates a network request to retrieve the contents of a URL based on the specified router.
    ///
    /// - Parameters:
    ///   - router: The router request.
    ///   - completion: A handler to be called once the request has finished.
    func request(_ route: APIRoutable, completion: @escaping (Result<NetworkAPI.Response, NetworkAPI.Error>) -> Void) {
        let urlRequest: URLRequest
        
        // Construct request
        do {
            urlRequest = try route.asURLRequest(constants: constants)
        } catch {
            return completion(.failure(NetworkAPI.Error(urlRequest: nil, statusCode: 400)))
        }
        
        log.request(urlRequest, environment: constants.environment)
        
        session.request(urlRequest) {
            self.log.response(
                try? $0.get(), url: urlRequest.url?.absoluteString,
                environment: self.constants.environment
            )
            
            completion($0)
        }
    }
}

// MARK: - Network logging helpers

private extension LogProviderType {
    
    /// Log URL request which help during debugging (low priority; not written to file)
    func request(_ request: URLRequest?, environment: Environment, path: String = #file, function: String = #function, line: Int = #line) {
        guard environment != .production else { return }
        
        let message: String = {
            var output = "Request: {\n"
            guard let request = request else { return "Request: empty" }
            
            if let value = request.url?.absoluteString {
                output += "\turl: \(value),\n"
            }
            
            if let value = request.httpMethod {
                output += "\tmethod: \(value),\n"
            }
            
            if let value = request.allHTTPHeaderFields?.scrubbed {
                output += "\theaders: \(value)\n"
            }
            
            output += "}"
            return output
        }()
        
        debug(message, path: path, function: function, line: line, context: nil)
    }
    
    /// Log HTTP response which help during debugging (low priority; not written to file)
    func response(_ response: NetworkAPI.Response?, url: String?, environment: Environment, path: String = #file, function: String = #function, line: Int = #line) {
        guard environment != .production else { return }
        
        let message: String = {
            var message = "Response: {\n"
            
            if let value = url {
                message += "\turl: \(value),\n"
            }
            
            if let response = response {
                message += "\tstatus: \(response.statusCode),\n"
                message += "\theaders: \(response.headers.scrubbed)\n"
            }
            
            message += "}"
            return message
        }()
        
        debug(message, path: path, function: function, line: line, context: nil)
    }
}

