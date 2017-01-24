//
//  PostRouter.swift
//  SwiftyPress
//
//  Created by Basem Emara on 1/23/17.
//
//

import Foundation
import Alamofire

enum PostRouter: URLRequestConvertible {
    case readPost(Int)
    case readPosts(Int, Int, String, Bool)
    case commentCount(Int)
    case commentsCount
    
    static let baseURLString = AppGlobal.userDefaults[.baseURL]

    var method: HTTPMethod {
        switch self {
        case .readPost: return .get
        case .readPosts: return .get
        case .commentCount: return .get
        case .commentsCount: return .get
        }
    }

    var path: String {
        switch self {
        case .readPost(let id):
            return "/posts/\(id)"
        case .readPosts(_, _, _, _):
            return "/posts"
        case .commentCount(let id):
            return ("/comments/\(id)/count")
        case .commentsCount:
            return "/comments/count"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try PostRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url
            .appendingPathComponent(AppGlobal.userDefaults[.baseREST])
            .appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .readPosts(let page, let perPage, let orderBy, let ascending):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [
                "page": page,
                "per_page": perPage,
                "orderby": orderBy,
                "order": ascending ? "asc" : "desc"
            ])
        case .commentsCount, .commentCount(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [
                "cache": Date().timeIntervalSince1970 as Any
            ])
        default: break
        }

        return urlRequest
    }
}
