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
    case readTerms(TaxonomyType, Int, String, Bool)
    
    static let baseURLString = AppGlobal.userDefaults[.baseURL]

    var method: HTTPMethod {
        switch self {
        case .readTerm: return .get
        case .readTerms: return .get
        }
    }

    var path: String {
        func getResource(for taxonomy: TaxonomyType) -> String {
            return taxonomy == .category ? "categories" : "tags"
        }
        
        switch self {
        case .readTerm(let taxonomy, let id):
            return "/\(getResource(for: taxonomy))/\(id)"
        case .readTerms(let taxonomy, _, _, _):
            return "/\(getResource(for: taxonomy))"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try TermRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url
            .appendingPathComponent(AppGlobal.userDefaults[.wpREST])
            .appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .readTerms(_, let perPage, let orderBy, let ascending):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [
                "per_page": perPage,
                "orderby": orderBy,
                "order": ascending ? "asc" : "desc"
            ])
        default: break
        }

        return urlRequest
    }
}
