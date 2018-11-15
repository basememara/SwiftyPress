//
//  AuthorsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public struct AuthorsWorker: AuthorsWorkerType {
    private let store: AuthorsStore
    
    public init(store: AuthorsStore) {
        self.store = store
    }
}

public extension AuthorsWorker {
    
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void) {
        store.fetch(id: id, completion: completion)
    }
}
