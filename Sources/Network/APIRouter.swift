//
//  APIRouter.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Alamofire

public protocol APIRoutable {
    func asURLRequest(constants: ConstantsType) throws -> URLRequest
}

public enum APIRouter: APIRoutable {
    case modified(after: Date?)
    case readPost(id: Int)
}

private extension APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .modified:
            return .get
        case .readPost:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .modified:
            return "modified"
        case .readPost(let id):
            return "post/\(id)"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .modified(let after):
            guard let timestamp = after?.timeIntervalSince1970 else { return [:] }
            return ["after": Int(timestamp)]
        case .readPost:
            return [:]
        }
    }
}

public extension APIRouter {
    
    func asURLRequest(constants: ConstantsType) throws -> URLRequest {
        var urlRequest = URLRequest(url:
            constants.baseURL
                .appendingPathComponent(constants.baseREST)
                .appendingPathComponent(path)
        )
        
        urlRequest.httpMethod = method.rawValue
        
        // Set timeout so errors return promptly instead of user waiting long
        urlRequest.timeoutInterval = {
            // Increase connection timeout since some payloads can be large
            switch self {
            case .modified:
                return 30
            default:
                return 10
            }
        }()
        
        // Encode parameters accordingly
        switch method {
        case .get:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
