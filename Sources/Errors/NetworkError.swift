//
//  NetworkError.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-17.
//

/// The NetworkError type represents an error object returned from the API server.
public struct NetworkError: Error {
    let urlRequest: URLRequest?
    let headerValues: [String: String]
    let serverData: Data?
    public let statusCode: Int
    public let internalError: Error?
    
    /// The initializer for the network error type.
    ///
    /// - Parameters:
    ///   - urlRequest: The URL that was requested.
    ///   - statusCode: The HTTP status code response from the network server.
    ///   - headerValues: The HTTP headers response from the network server.
    ///   - serverData: The HTTP body response from the network server.
    ///   - internalError: The internal error from the network request.
    public init(
        urlRequest: URLRequest? = nil,
        statusCode: Int,
        headerValues: [String: String] = [String: String](),
        serverData: Data? = nil,
        internalError: Error? = nil)
    {
        self.urlRequest = urlRequest
        self.statusCode = statusCode
        self.headerValues = headerValues
        self.serverData = serverData
        self.internalError = internalError
    }
}

extension NetworkError: CustomStringConvertible {
    public var description: String {
        return """
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
