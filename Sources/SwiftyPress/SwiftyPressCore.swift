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
    
    func dataRepository() -> DataRepositoryType
    func seedService() -> SeedService
    func remoteService() -> RemoteService
    func cacheService() -> CacheService
    
    func postRepository() -> PostRepositoryType
    func postService() -> PostService
    func postRemote() -> PostRemote
    
    func authorRepository() -> AuthorRepositoryType
    func authorService() -> AuthorService
    func authorRemote() -> AuthorRemote
    
    func mediaRepository() -> MediaRepositoryType
    func mediaService() -> MediaService
    func mediaRemote() -> MediaRemote
    
    func taxonomyRepository() -> TaxonomyRepositoryType
    func taxonomyService() -> TaxonomyService
    
    func networkRepository() -> NetworkRepository
    func networkService() -> NetworkService
    
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
    
    func dataRepository() -> DataRepositoryType {
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
    
    func postRepository() -> PostRepositoryType {
        PostRepository(
            service: postService(),
            remote: postRemote(),
            dataRepository: dataRepository(),
            preferences: preferences(),
            constants: constants(),
            log: log()
        )
    }
    
    func postService() -> PostService {
        PostRealmService(log: log())
    }
    
    func postRemote() -> PostRemote {
        PostNetworkRemote(
            networkRepository: networkRepository(),
            jsonDecoder: jsonDecoder(),
            constants: constants(),
            log: log()
        )
    }
}

public extension SwiftyPressCore {
    
    func authorRepository() -> AuthorRepositoryType {
        AuthorRepository(
            service: authorService(),
            remote: authorRemote(),
            log: log()
        )
    }
    
    func authorService() -> AuthorService {
        AuthorRealmService()
    }
    
    func authorRemote() -> AuthorRemote {
        AuthorNetworkRemote(
            networkRepository: networkRepository(),
            jsonDecoder: jsonDecoder(),
            constants: constants(),
            log: log()
        )
    }
}

public extension SwiftyPressCore {
    
    func mediaRepository() -> MediaRepositoryType {
        MediaRepository(
            service: mediaService(),
            remote: mediaRemote()
        )
    }
    
    func mediaService() -> MediaService {
        MediaRealmService(log: log())
    }
    
    func mediaRemote() -> MediaRemote {
        MediaNetworkRemote(
            networkRepository: networkRepository(),
            jsonDecoder: jsonDecoder(),
            constants: constants(),
            log: log()
        )
    }
}

public extension SwiftyPressCore {
    
    func taxonomyRepository() -> TaxonomyRepositoryType {
        TaxonomyRepository(
            service: taxonomyService(),
            dataRepository: dataRepository()
        )
    }
    
    func taxonomyService() -> TaxonomyService {
        TaxonomyRealmService(log: log())
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
    
    func log() -> LogRepository {
        LogRepository(services: logServices())
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
