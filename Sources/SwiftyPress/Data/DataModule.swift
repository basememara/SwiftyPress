//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-09-11.
//

import Foundation

public struct DataModule: Module {
    
    public func resolve() {
        factory {
            DataWorker(
                constants: self.resolve(),
                seedStore: self.resolve(),
                remoteStore: self.resolve(),
                cacheStore: self.resolve()
            ) as DataWorkerType
        }
        
        factory { RemoteNetworkStore(apiSession: self.resolve()) as RemoteStore }
        factory { CacheRealmStore(preferences: self.resolve()) as CacheStore }
    }
}
