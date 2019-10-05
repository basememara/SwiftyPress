//
//  NetworkAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-13.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

// Namespace for module
public enum NetworkAPI {}

public extension NetworkAPI {
    
    struct Response {
        let data: Data
        let headers: [String: String]
        let statusCode: Int
    }
}

public extension NetworkAPI {
    
    struct Error: Swift.Error {
        let urlRequest: URLRequest?
        let headerValues: [String: String]
        let serverData: Data?
        let serverDetails: Response?
        
        public let statusCode: Int
        public let internalError: Swift.Error?
        
        /// The initializer for the network error type.
        ///
        /// - Parameters:
        ///   - urlRequest: The URL that was requested.
        ///   - statusCode: The HTTP status code response from the network server.
        ///   - headerValues: The HTTP headers response from the network server.
        ///   - serverData: The HTTP body response from the network server.
        ///   - internalError: The internal error from the network request.
        init(
            urlRequest: URLRequest? = nil,
            statusCode: Int,
            headerValues: [String: String] = [String: String](),
            serverData: Data? = nil,
            internalError: Swift.Error? = nil
        ) {
            self.urlRequest = urlRequest
            self.statusCode = statusCode
            self.headerValues = headerValues
            self.serverData = serverData
            self.internalError = internalError
            
            if let serverData = serverData {
                self.serverDetails = try? JSONDecoder.default.decode(
                    Response.self,
                    from: serverData
                )
            } else {
                self.serverDetails = nil
            }
        }
    }
}

extension NetworkAPI.Error {
    
    // Type used for decoding the server error
    struct Response: Decodable {
        let code: String
        let message: String
        let data: [String: AnyDecodable]?
    }
}

extension NetworkAPI.Error: CustomStringConvertible {
    
    public var description: String {
        """
        \(internalError ?? DataError.unknownReason(nil))
        Request: {
            url: \(urlRequest?.url?.absoluteString ?? ""),
            method: \(urlRequest?.httpMethod ?? ""),
            headers: \(urlRequest?.allHTTPHeaderFields?.scrubbed ?? [:]),
        },
        Response: {
            status: \(statusCode),
            headers: \(headerValues.scrubbed)
        }
        """
    }
}
