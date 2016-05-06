//
//  Router.swift
//  SwiftyPress
//
//  Created by Basem Emara on 3/28/16.
//
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case ReadPost(Int)
    case ReadPosts()

    var URLRequest: NSMutableURLRequest {
        let result: (path: String, parameters: [String: AnyObject]) = {
            switch self {
            case .ReadPost(let ID):
                return ("/\(AppGlobal.userDefaults[.baseREST])/\(ID)", [:])
            case .ReadPosts:
                return ("/\(AppGlobal.userDefaults[.baseREST])", ["filter": [
                    "posts_per_page": 50,
                    "orderby": "date",
                    "order": "desc",
                    "page": 1
                ]])
            }
        }()

        let URL = NSURL(string: AppGlobal.userDefaults[.baseURL])!
        let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        let encoding = Alamofire.ParameterEncoding.URL

        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
}