//
//  APISession.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Alamofire
import ZamzamKit

public protocol APISessionType {
    func request(_ route: APIRoutable, completion: @escaping (Swift.Result<ServerResponse, NetworkError>) -> Void)
}

public struct APISession: APISessionType, Loggable {
    private let sessionManager: SessionManager
    private let constants: ConstantsType
    
    public init(constants: ConstantsType) {
        // Construct URL session manager
        let configuration = URLSessionConfiguration.default
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        self.constants = constants
    }
}

public extension APISession {
    
    /// Creates a network request to retrieve the contents of a URL based on the specified router.
    ///
    /// - Parameters:
    ///   - router: The router request.
    ///   - completion: A handler to be called once the request has finished.
    func request(_ route: APIRoutable, completion: @escaping (Swift.Result<ServerResponse, NetworkError>) -> Void) {
        let urlRequest: URLRequest
        
        // Construct request
        do {
            urlRequest = try route.asURLRequest(constants: constants)
        } catch {
            return completion(.failure(NetworkError(urlRequest: nil, statusCode: 400)))
        }
        
        Log(request: urlRequest)
        
        sessionManager.request(urlRequest) {
            self.Log(response: try? $0.get(), url: urlRequest.url?.absoluteString)
            completion($0)
        }
    }
}
