//
//  APISession.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest
import ZamzamCore

extension LogRepository {
    
    /// Log URL request which help during debugging (low priority; not written to file)
    func request(
        _ request: URLRequest?,
        isDebug: Bool,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isDebug else { return }
        
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
        
        debug(message, file: file, function: function, line: line, context: [:])
    }
    
    /// Log HTTP response which help during debugging (low priority; not written to file)
    func response(
        _ response: NetworkAPI.Response?,
        url: String?,
        isDebug: Bool,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isDebug else { return }
        
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
        
        debug(message, file: file, function: function, line: line, context: [:])
    }
}
