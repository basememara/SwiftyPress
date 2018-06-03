//
//  AuthorsStoreInterfaces.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//

import ZamzamKit

public protocol AuthorsWorkerType {
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void)
}

public struct AuthorsWorker: AuthorsWorkerType {
    
}

public extension AuthorsWorker {
    
    func fetch(id: Int, completion: @escaping (Result<AuthorType, DataError>) -> Void) {
        let author = Author(
            id: 1,
            name: "Basem Emara",
            link: "https://basememara.com",
            avatar: "http://2.gravatar.com/avatar/8def0d36f56d3e6720a44e41bf6f9a71?s=96&d=mm&r=g",
            content: "Basem is a mobile and software IT professional with over 12 years of experience as an architect, developer, and consultant for dozens of projects that span over various industries for Fortune 500 enterprises, government agencies, and startups. In 2014, Basem brought his vast knowledge and experiences to Swift and helped pioneer the language to build scalable enterprise iOS &amp; watchOS apps, later providing mentorship courses at <a href=\"https://iosmentor.io\">https://iosmentor.io</a>.",
            createdAt: Date(),
            modifiedAt: Date()
        )
        
        guard id == author.id else { return completion(.failure(.nonExistent)) }
        completion(.success(author))
    }
}
