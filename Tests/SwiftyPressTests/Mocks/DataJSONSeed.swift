//
//  File.swift
//  
//
//  Created by Basem Emara on 2020-05-11.
//

#if !os(watchOS)
import Foundation.NSJSONSerialization
import ZamzamCore
@testable import SwiftyPress

struct DataJSONSeed: DataSeed {
    private static var seed: SeedPayload?
    
    func configure() {}
    
    func fetch(completion: (Result<SeedPayload, SwiftyPressError>) -> Void) {
        if Self.seed == nil {
            do {
                Self.seed = try JSONDecoder.default.decode(
                    SeedPayload.self,
                    fromJSON: #file
                )
            } catch {
                completion(.failure(.parseFailure(error)))
                return
            }
        }
        
        guard let seed = Self.seed else {
            completion(.failure(.nonExistent))
            return
        }
        
        completion(.success(seed))
    }
}
#endif
