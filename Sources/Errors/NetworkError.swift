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
    public let statusCode: Int
    public let internalError: Error?
    
    /// The initializer for the NetworkError type.
    ///
    /// - Parameters:
    ///   - statusCode: Status code of the network response.
    ///   - serverResponse: The array of field errors from the server.
    ///   - internalError: The internal error type from the network request.
    public init(urlRequest: URLRequest?, statusCode: Int, headerValues: [String: String] = [String: String](), internalError: Error? = nil) {
        self.urlRequest = urlRequest
        self.statusCode = statusCode
        self.headerValues = headerValues
        self.internalError = internalError
    }
    
    /// The initializer for the NetworkError type.
    ///
    /// - Parameters:
    ///   - statusCode: Status code of the network response.
    ///   - serverData: The data from the server that contains the error and corresponding fields.
    ///   - internalError: The internal error type from the network request.
    public init(urlRequest: URLRequest?, statusCode: Int, headerValues: [String: String], serverData: Data?, internalError: Error?) {
        self.init(urlRequest: urlRequest, statusCode: statusCode, headerValues: headerValues, internalError: internalError)
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
