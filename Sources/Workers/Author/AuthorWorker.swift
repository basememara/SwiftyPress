//
//  AuthorsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public struct AuthorWorker: AuthorWorkerType {
    private let store: AuthorStore
    
    public init(store: AuthorStore) {
        self.store = store
    }
}

public extension AuthorWorker {
    
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void) {
        store.fetch(id: id, completion: completion)
    }
}
