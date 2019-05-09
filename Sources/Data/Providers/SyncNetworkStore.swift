//
//  SeedNetworkStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//

import ZamzamKit

public struct SyncNetworkStore: SyncStore, Loggable {
    private let apiSession: APISessionType
    
    public init(apiSession: APISessionType) {
        self.apiSession = apiSession
    }
}

public extension SyncNetworkStore {
    
    func configure() {
        // No configure needed
    }
    
    func fetchModified(after date: Date, completion: @escaping (Result<SeedPayload, DataError>) -> Void) {
        apiSession.request(APIRouter.modifiedPayload(after: date)) {
            guard case .success(let value) = $0 else {
                // Handle no modified data and return success
                guard $0.error?.statusCode != 304 else {
                    return completion(.success(SeedPayload()))
                }
                
                self.Log(error: "An error occured while fetching the modified payload: \(String(describing: $0.error)).")
                return completion(.failure(DataError(from: $0.error)))
            }
            
            DispatchQueue.transform.async {
                do {
                    // Parse response data
                    let payload = try JSONDecoder.default.decode(SeedPayload.self, from: value.data)
                    DispatchQueue.main.async { completion(.success(payload)) }
                } catch {
                    self.Log(error: "An error occured while parsing the modified payload: \(error).")
                    return DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                }
            }
        }
    }
}
