//
//  AuthorRepository.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate
import ZamzamCore

public struct AuthorRepository {
    private let service: AuthorService
    private let cache: AuthorCache?
    private let log: LogRepository
    
    public init(service: AuthorService, cache: AuthorCache?, log: LogRepository) {
        self.service = service
        self.cache = cache
        self.log = log
    }
}

// MARK: - Retrievals

public extension AuthorRepository {
    
    /// Returns the specified author.
    ///
    ///     authorRepository.fetch(with: request) { result in
    ///         switch result {
    ///         case .initial(let item):
    ///             // prepare UI
    ///         case .update(let item):
    ///             // diff UI
    ///         case .failure(let error):
    ///             // present error
    ///         }
    ///     }
    ///
    /// This returns the data from the cache immediately in the `.initial` case, but then checks the remote service
    /// for updates one time by comparing against the data residing in the cache and calls the `.update` case if there
    /// is a change from the initial state. This fetches from the cache and service one time only.
    ///
    /// - Parameters:
    ///   - request: The request of the fetch query.
    ///   - completion: The block to execute with the initial and updated results if available.
    func fetch(with request: AuthorAPI.FetchRequest, change completion: @escaping (ChangeResult<Author, SwiftyPressError>) -> Void) {
        guard let cache = cache else {
            service.fetch(with: request, completion: { $0(completion) })
            return
        }
        
        cache.fetch(with: request) { result in
            if case .nonExistent? = result.error {
                self.log.debug("Local cache empty for author, refreshing...")
                self.refresh(with: request, completion: { $0(completion) })
                return
            }
            
            guard case let .success(cacheItem) = result else {
                completion(.failure(result.error ?? .cacheFailure(nil)))
                return
            }
            
            self.log.debug("Immediately return cached response and check remote service...")
            completion(.initial(cacheItem))
            
            self.service.fetch(with: request) { result in
                guard case let .success(item) = result else { return }
                
                // Validate if any updates occurred and return
                guard item != cacheItem else { return }
                
                self.log.debug("Service data updates exist, saving to cache...")
                
                // Update local storage with updated data
                cache.createOrUpdate(item) { result in
                    guard case .success = result else { return }
                    completion(.update(item))
                }
            }
        }
    }
    
    /// Requests the latest author from the service.
    ///
    /// This updates the cache if there is newer data from the service. If there are
    /// any observers subscribed to the cache, they will be notified of the update.
    ///
    /// - Parameters:
    ///   - request: The request of the fetch query.
    ///   - cacheExpiry: The cache expiry time in seconds to throttle requests before making new requests. If `0` is specified, the service is requested every time.
    func fetch(with request: AuthorAPI.FetchRequest, cacheExpiry: Int = 0) {
        refresh(with: request, cacheExpiry: cacheExpiry)
    }
}

// MARK: - Observables

public extension AuthorRepository {
    
    /// Registers a block to be called each time the author changes or is removed.
    ///
    ///     authorRepository
    ///         .subscribe(with: request) { [weak self] result in
    ///             switch result {
    ///             case .initial(let item):
    ///                 // prepare UI
    ///             case .update(let item):
    ///                 // diff UI
    ///             case .failure(let error):
    ///                 // present error
    ///             }
    ///         }
    ///         .store(in: &self.cancellable)
    ///
    /// The block will be asynchronously called with the initial results in the `.initial` case , and then called again
    /// after each cache update from the service in the `.update` case . Call `fetch` to trigger a call to the service
    /// to check for updates, otherwise only the initial results from the cache is returned.
    ///
    /// - Parameters:
    ///   - request: The request of the fetch query.
    ///   - block: The block to be called with the initial state and whenever a change occurs.
    /// - Returns: Returns an object to registister a token. Call `store` on the returned
    ///     object with a token, which must be held for as long as you want updates to be delivered.
    func subscribe(
        with request: AuthorAPI.FetchRequest,
        change block: @escaping (ChangeResult<Author, SwiftyPressError>) -> Void
    ) -> AuthorAPI.FetchCancellable {
        AuthorAPI.FetchCancellable(
            service: service,
            cache: cache,
            request: request,
            change: block
        )
    }
}

// MARK: - Helpers

private extension AuthorRepository {
    static var lastFetchPageRefreshed = Synchronized<[AnyHashable: Date]>([:])
    
    func refresh(with request: AuthorAPI.FetchRequest, cacheExpiry: Int = 0, completion: ((Result<Author, SwiftyPressError>) -> Void)? = nil) {
        // Skip if cache refreshed from server within expiry time window
        guard cacheExpiry == 0 || Date().isBeyond(Self.lastFetchPageRefreshed.value[request] ?? .distantPast, bySeconds: cacheExpiry) else {
            self.log.debug("Skipped refreshed cache from the service for author")
            return
        }
        
        // Remember last cached date to throttle requests
        Self.lastFetchPageRefreshed.value { $0[request] = Date() }
        
        guard let cache = cache else {
            service.fetch(with: request, completion: completion ?? { _ in })
            return
        }
        
        service.fetch(with: request) { result in
            guard case let .success(item) = result else {
                completion?(result)
                return
            }
            
            cache.createOrUpdate(item) { result in
                defer { completion?(result) }
                guard case .success = result else { return }
                self.log.debug("Successfully refreshed cache from the service for author")
            }
        }
    }
}
