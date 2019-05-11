//
//  AuthorsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

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
