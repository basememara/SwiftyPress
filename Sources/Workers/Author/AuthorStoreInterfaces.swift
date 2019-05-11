//
//  AuthorsStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public protocol AuthorStore {
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void)
}

public protocol AuthorWorkerType: AuthorStore {

}
