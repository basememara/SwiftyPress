//
//  TermRouter.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2/12/17.
//
//

import Foundation
import Alamofire

enum TermRouter: URLRequestConvertible {
    case readTerm(TaxonomyType, Int)
    case readTerms(TaxonomyType, String, Bool, Int)
    
    static let baseURLString = AppGlobal.userDefaults[.baseURL]

    var method: HTTPMethod {
        switch self {
        case .readTerm: return .get
        case .readTerms: return .get
        }
    }

    var path: String {
        switch self {
        case .readTerm(let taxonomy, let id):
            return "/\(taxonomy.rawValue)/\(id)"
        case .readTerms(let taxonomy, _, _, _):
            return "/\(taxonomy.rawValue)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try TermRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url
            .appendingPathComponent(AppGlobal.userDefaults[.wpREST])
            .appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .readTerms(_, let orderBy, let ascending, let number):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [
                "orderby": orderBy,
                "order": ascending ? "asc" : "desc",
                "number": number
            ])
        default: break
        }

        return urlRequest
    }
}
