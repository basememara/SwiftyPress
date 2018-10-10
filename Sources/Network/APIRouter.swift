//
//  APIRouter.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//

import Alamofire

public enum APIRouter: APIRoutable {
    case modifiedPayload(after: Date?)
}

private extension APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .modifiedPayload: return .get
        }
    }
    
    var path: String {
        switch self {
        case .modifiedPayload: return "payloads/modified"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .modifiedPayload(let after):
            guard let timestamp = after?.timeIntervalSince1970 else {
                return [:]
            }
            
            return ["after": Int(timestamp)]
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
            case .modifiedPayload: return 30
            }
        }()
        
        switch self {
        case .modifiedPayload:
            guard !parameters.isEmpty else { break }
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
