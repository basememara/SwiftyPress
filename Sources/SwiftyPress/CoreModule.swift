//
//  SwiftyPressConfigurator.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore
import ZamzamUI

public struct CoreModule: Module {
    
    public init() {}
    
    public func register() {
        make { Constants(store: self.resolve()) as ConstantsType }
        make { Preferences(store: self.resolve()) as PreferencesType }
        make {
            DataWorker(
                constants: self.resolve(),
                seedStore: self.resolve(),
                remoteStore: self.resolve(),
                cacheStore: self.resolve()
            ) as DataWorkerType
        }
        make { RemoteNetworkStore(apiSession: self.resolve()) as RemoteStore }
        make { CacheRealmStore(preferences: self.resolve()) as CacheStore }
        make {
            PostWorker(
                store: self.resolve(),
                remote: self.optional(),
                preferences: self.resolve(),
                constants: self.resolve(),
                dataWorker: self.resolve()
            ) as PostWorkerType
        }
        make { PostRealmStore() as PostStore }
        make { PostNetworkRemote(apiSession: self.resolve()) as PostRemote }
        make {
            AuthorWorker(
                store: self.resolve(),
                remote: self.optional()
            ) as AuthorWorkerType
        }
        make { AuthorRealmStore() as AuthorStore }
        make { AuthorNetworkRemote(apiSession: self.resolve()) as AuthorRemote }
        make {
            MediaWorker(
                store: self.resolve(),
                remote: self.optional()
            ) as MediaWorkerType
        }
        make { MediaRealmStore() as MediaStore }
        make { MediaNetworkRemote(apiSession: self.resolve()) as MediaRemote }
        make {
            TaxonomyWorker(
                store: self.resolve(),
                dataWorker: self.resolve()
            ) as TaxonomyWorkerType
        }
        make { TaxonomyRealmStore() as TaxonomyStore }
        make { .default as NotificationCenter }
        make { APISession(constants: self.resolve()) as APISessionType }
        make { HTTPService() as HTTPServiceType }
        make { SwiftyTheme() as Theme }
        
        #if os(iOS)
        make {
            MailComposer(
                delegate: nil,
                styleNavigationBar: {
                    let theme: Theme = self.resolve()
                    $0.tintColor = theme.tint
                }
            ) as MailComposerType
        }
        #endif
    }
}
