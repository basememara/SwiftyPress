//
//  SeedFileStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public struct SeedFileStore: SeedStore {
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
        guard Self.data == nil else { return }
        
        Self.data = try? JSONDecoder.default.decode(
            SeedPayload.self,
            forResource: name,
            inBundle: bundle
        )
    }
}

public extension SeedFileStore {
    
    func fetch(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        completion(.success(Self.data ?? SeedPayload()))
    }
}

public extension SeedFileStore {
    
    func set(data: SeedPayloadType) {
        Self.data = data
    }
}
