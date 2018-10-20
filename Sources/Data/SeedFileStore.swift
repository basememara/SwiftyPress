//
//  SeedFileStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public struct SeedFileStore: SeedStore, Loggable {
    private static var data: ModifiedPayload?
    
    private let name: String
    private let bundle: Bundle
    
    public init(forResource name: String, inBundle bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }
}

public extension SeedFileStore {
    
    func setup() {
        guard SeedFileStore.data == nil else { return }
        
        SeedFileStore.data = try! JSONDecoder.default.decode(
            ModifiedPayload.self,
            forResource: name,
            inBundle: bundle
        )
    }
}

public extension SeedFileStore {
    
    func fetch(completion: @escaping (Result<ModifiedPayload, DataError>) -> Void) {
        completion(.success(SeedFileStore.data ?? ModifiedPayload()))
    }
}

public extension SeedFileStore {
    
    func set(data: ModifiedPayload) {
        SeedFileStore.data = data
    }
}
