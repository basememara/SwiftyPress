//
//  SeedFileService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle
import ZamzamCore

public struct SeedFileService: SeedService {
    private static var data: SeedPayloadType?
    
    private let name: String
    private let bundle: Bundle
    private let jsonDecoder: JSONDecoder
    
    public init(forResource name: String, inBundle bundle: Bundle, jsonDecoder: JSONDecoder) {
        self.name = name
        self.bundle = bundle
        self.jsonDecoder = jsonDecoder
    }
}

public extension SeedFileService {
    
    func configure() {
        guard Self.data == nil else { return }
        
        Self.data = try? jsonDecoder.decode(
            SeedPayload.self,
            forResource: name,
            inBundle: bundle
        )
    }
}

public extension SeedFileService {
    
    func fetch(completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        completion(.success(Self.data ?? SeedPayload()))
    }
}

public extension SeedFileService {
    
    func set(data: SeedPayloadType) {
        Self.data = data
    }
}
