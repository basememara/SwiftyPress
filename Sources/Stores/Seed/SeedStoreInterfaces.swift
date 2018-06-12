//
//  SeedStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public protocol SeedStore {
    func fetchModified(after date: Date?, completion: @escaping (Result<ModifiedPayload, DataError>) -> Void)
}

public protocol SeedWorkerType: SeedStore {
    
}

public extension SeedStore {
    
    func fetch(completion: @escaping (Result<ModifiedPayload, DataError>) -> Void) {
        fetchModified(after: nil, completion: completion)
    }
}
