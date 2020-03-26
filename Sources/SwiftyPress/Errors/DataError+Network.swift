//
//  DataError+Network.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2020-03-26.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLError
import ZamzamCore

public extension DataError {
    
    init(from error: NetworkAPI.Error?) {
        // Handle no internet
        if let internalError = error?.internalError as? URLError,
            internalError.code  == .notConnectedToInternet {
            self = .noInternet
            return
        }
        
        // Handle timeout
        if let internalError = error?.internalError as? URLError,
            internalError.code  == .timedOut {
            self = .timeout
            return
        }
        
        // Handle by status code
        switch error?.statusCode {
        case 400?:
            self = .requestFailure(error)
        case 401?, 403?:
            self = .unauthorized
        default:
            self = .serverFailure(error)
        }
    }
}
