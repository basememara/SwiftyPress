//
//  AuthorAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

// MARK: - Services

public protocol AuthorService {
    func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void)
}

// MARK: - Cache

public protocol AuthorCache {
    func fetch(with request: AuthorAPI.FetchRequest, completion: @escaping (Result<Author, SwiftyPressError>) -> Void)
    func createOrUpdate(_ request: Author, completion: @escaping (Result<Author, SwiftyPressError>) -> Void)
    
    func subscribe(
        with request: AuthorAPI.FetchRequest,
        in cancellable: inout Cancellable?,
        change block: @escaping (ChangeResult<Author, SwiftyPressError>) -> Void
    )
}

// MARK: - Namespace

public enum AuthorAPI {
    
    public struct FetchRequest: Hashable {
        public let id: Int
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct FetchCancellable {
        private let service: AuthorService
        private let cache: AuthorCache?
        private let request: FetchRequest
        private let block: (ChangeResult<Author, SwiftyPressError>) -> Void
        
        init(
            service: AuthorService,
            cache: AuthorCache?,
            request: FetchRequest,
            change block: @escaping (ChangeResult<Author, SwiftyPressError>) -> Void
        ) {
            self.service = service
            self.cache = cache
            self.request = request
            self.block = block
        }
        
        /// Stores the cancellable object for subscriptions to be delievered during its lifetime.
        ///
        /// A subscription is automatically cancelled when the object is deinitialized.
        ///
        /// - Parameter cancellable: A subscription token which must be held for as long as you want updates to be delivered.
        public func store(in cancellable: inout Cancellable?) {
            guard let cache = cache else {
                service.fetch(with: request, completion: { $0(self.block) })
                return
            }
            
            cache.subscribe(with: request, in: &cancellable, change: block)
        }
    }
}
