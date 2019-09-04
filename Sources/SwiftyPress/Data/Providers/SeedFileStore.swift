//
//  SeedFileStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct SeedFileStore: SeedStore, Loggable {
    private static var data: SeedPayloadType?
    
    private let name: String
    private let bundle: Bundle
    
    public init(forResource name: String, inBundle bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }
}

public extension SeedFileStore {
    
    func configure() {
        guard SeedFileStore.data == nil else { return }
        
        SeedFileStore.data = try? JSONDecoder.default.decode(
            SeedPayload.self,
            forResource: name,
            inBundle: bundle
        )
    }
}

public extension SeedFileStore {
    
    func fetch(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        completion(.success(SeedFileStore.data ?? SeedPayload()))
    }
}

public extension SeedFileStore {
    
    func set(data: SeedPayloadType) {
        SeedFileStore.data = data
    }
}
