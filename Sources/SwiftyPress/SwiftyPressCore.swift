//
//  SwiftyPressConfigurator.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.v
//

import Foundation.NSFileManager
import Foundation.NSJSONSerialization
import Foundation.NSNotification
import ZamzamCore
import ZamzamUI

public protocol SwiftyPressCore {
    func constants() -> Constants
    func constantsService() -> ConstantsService
    
    func preferences() -> Preferences
    func preferencesService() -> PreferencesService
    
    func log() -> LogRepository
    func logServices() -> [LogService]
    
    func networkRepository() -> NetworkRepository
    func networkService() -> NetworkService
    
    func dataRepository() -> DataRepository
    func seedService() -> SeedService
    func remoteService() -> RemoteService
    func cacheService() -> CacheService
    
    func postRepository() -> PostRepository
    func postService() -> PostService
    func postCache() -> PostCache
    
    func authorRepository() -> AuthorRepository
    func authorService() -> AuthorService
    func authorCache() -> AuthorCache
    
    func mediaRepository() -> MediaRepository
    func mediaService() -> MediaService
    func mediaCache() -> MediaCache
    
    func taxonomyRepository() -> TaxonomyRepository
    func taxonomyCache() -> TaxonomyCache
    
    func notificationCenter() -> NotificationCenter
    func fileManager() -> FileManager
    func jsonDecoder() -> JSONDecoder
    
    func theme() -> Theme
    
    #if os(iOS)
    @available(iOS 10.0, *)
    func mailComposer(delegate: MailComposerDelegate?) -> MailComposerType
    #endif
}

// MARK: - Defaults

public extension SwiftyPressCore {
    
    func constants() -> Constants {
        Constants(service: constantsService())
    }
}

public extension SwiftyPressCore {
    
    func preferences() -> Preferences {
        Preferences(service: preferencesService())
    }
}

public extension SwiftyPressCore {
    
    func log() -> LogRepository {
        LogRepository(services: logServices())
    }
}

public extension SwiftyPressCore {
    
    func networkRepository() -> NetworkRepository {
        NetworkRepository(service: networkService())
    }
    
    func networkService() -> NetworkService {
        NetworkFoundationService()
    }
}

public extension SwiftyPressCore {
    
    func dataRepository() -> DataRepository {
        DataRepository(
            seedService: seedService(),
            remoteService: remoteService(),
            cacheService: cacheService(),
            constants: constants(),
            log: log()
        )
    }
    
    func remoteService() -> RemoteService {
        RemoteNetworkService(
            networkRepository: networkRepository(),
            jsonDecoder: jsonDecoder(),
            constants: constants(),
            log: log()
        )
    }
    
    func cacheService() -> CacheService {
        CacheRealmService(
            fileManager: fileManager(),
            preferences: preferences(),
            log: log()
        )
    }
}

public extension SwiftyPressCore {
    
    func postRepository() -> PostRepository {
        PostRepository(
            service: postService(),
            cache: postCache(),
            dataRepository: dataRepository(),
            preferences: preferences(),
            constants: constants(),
            log: log()
        )
    }
    
    func postService() -> PostService {
        PostNetworkService(
            networkRepository: networkRepository(),
            jsonDecoder: jsonDecoder(),
            constants: constants(),
            log: log()
        )
    }
    
    func postCache() -> PostCache {
        PostRealmCache(log: log())
    }
}

public extension SwiftyPressCore {
    
    func authorRepository() -> AuthorRepository {
        AuthorRepository(
            service: authorService(),
            cache: authorCache(),
            log: log()
        )
    }
    
    func authorService() -> AuthorService {
        AuthorNetworkService(
            networkRepository: networkRepository(),
            jsonDecoder: jsonDecoder(),
            constants: constants(),
            log: log()
        )
    }
    
    func authorCache() -> AuthorCache {
        AuthorRealmCache()
    }
}

public extension SwiftyPressCore {
    
    func mediaRepository() -> MediaRepository {
        MediaRepository(
            service: mediaService(),
            cache: mediaCache()
        )
    }
    
    func mediaService() -> MediaService {
        MediaNetworkService(
            networkRepository: networkRepository(),
            jsonDecoder: jsonDecoder(),
            constants: constants(),
            log: log()
        )
    }
    
    func mediaCache() -> MediaCache {
        MediaRealmCache(log: log())
    }
}

public extension SwiftyPressCore {
    
    func taxonomyRepository() -> TaxonomyRepository {
        TaxonomyRepository(
            cache: taxonomyCache(),
            dataRepository: dataRepository()
        )
    }
    
    func taxonomyCache() -> TaxonomyCache {
        TaxonomyRealmCache(log: log())
    }
}

public extension SwiftyPressCore {
    
    func notificationCenter() -> NotificationCenter {
        .default
    }
    
    func fileManager() -> FileManager {
        .default
    }
    
    func jsonDecoder() -> JSONDecoder {
        .default
    }
}

public extension SwiftyPressCore {
    
    #if os(iOS)
    @available(iOS 10.0, *)
    func mailComposer(delegate: MailComposerDelegate? = nil) -> MailComposerType {
        let theme: Theme = self.theme()
        
        return MailComposer(
            delegate: delegate,
            styleNavigationBar: {
                $0.tintColor = theme.tint
            }
        )
    }
    #endif
}
