//
//  SeedWorker.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public struct SeedWorker: SeedWorkerType {
    private let store: SeedStore
    
    public init(store: SeedStore) {
        self.store = store
    }
}

public extension SeedWorker {
    
    func fetchModified(after date: Date?, completion: @escaping (Result<ModifiedPayload, DataError>) -> Void) {
        store.fetchModified(after: date, completion: completion)
    }
}
