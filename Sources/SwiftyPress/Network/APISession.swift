//
//  APISession.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Alamofire
import ZamzamCore

public protocol APISessionType {
    func request(_ route: APIRoutable, completion: @escaping (Swift.Result<NetworkModels.Response, NetworkModels.Error>) -> Void)
}

public struct APISession: APISessionType, Loggable {
    private let session: Session
    private let constants: ConstantsType
    
    public init(constants: ConstantsType) {
        self.session = .init(configuration: .default)
        self.constants = constants
    }
}

public extension APISession {
    
    /// Creates a network request to retrieve the contents of a URL based on the specified router.
    ///
    /// - Parameters:
    ///   - router: The router request.
    ///   - completion: A handler to be called once the request has finished.
    func request(_ route: APIRoutable, completion: @escaping (Swift.Result<NetworkModels.Response, NetworkModels.Error>) -> Void) {
        let urlRequest: URLRequest
        
        // Construct request
        do {
            urlRequest = try route.asURLRequest(constants: constants)
        } catch {
            return completion(.failure(NetworkModels.Error(urlRequest: nil, statusCode: 400)))
        }
        
        Log(request: urlRequest)
        
        session.request(urlRequest) {
            self.Log(response: try? $0.get(), url: urlRequest.url?.absoluteString)
            completion($0)
        }
    }
}
