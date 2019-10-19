//
//  APIRouter.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIRoutable {
    func asURLRequest(constants: ConstantsType) throws -> URLRequest
}

public enum APIRouter: APIRoutable {
    case modified(after: Date?, DataAPI.ModifiedRequest)
    case readPost(id: Int, PostsAPI.ItemRequest)
    case readAuthor(id: Int)
    case readMedia(id: Int)
}

private extension APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .modified:
            return .get
        case .readPost:
            return .get
        case .readAuthor:
            return .get
        case .readMedia:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .modified:
            return "modified"
        case .readPost(let id, _):
            return "post/\(id)"
        case .readAuthor(let id):
            return "author/\(id)"
        case .readMedia(let id):
            return "media/\(id)"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .modified(let after, let request):
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
        case .readPost(_, let request):
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
        case .readAuthor:
            return [:]
        case .readMedia:
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
