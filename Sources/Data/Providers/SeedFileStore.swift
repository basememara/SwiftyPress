//
//  SeedFileStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public struct SeedFileStore: SeedStore, Loggable {
    private static var data: SeedPayload?
    
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
    
    func fetch(completion: @escaping (Result<SeedPayload, DataError>) -> Void) {
        completion(.success(SeedFileStore.data ?? SeedPayload()))
    }
}

public extension SeedFileStore {
    
    func set(data: SeedPayload) {
        SeedFileStore.data = data
    }
}
