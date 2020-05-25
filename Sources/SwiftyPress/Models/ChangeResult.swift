//
//  ChangeResult.swift
//  SwiftPress
//
//  Created by Basem Emara on 2020-05-10.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// A value that represents information about changes to a value or a failure, including an associated value in each case.
@frozen public enum ChangeResult<Value, Failure> where Failure: Error {
    
    /// Indicates that the initial run of the result has completed.
    case initial(Value)
    
    /// Indicates that a modification of the value has occurred from the initial state previously returned.
    case update(Value)
    
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}

// MARK: - Helpers

public extension ChangeResult {
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    var error: Failure? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}

public extension Result {
    
    /// Transform `Result` to single `ChangeResult` by calling the initial or failure cases for convenience.
    ///
    ///     // Executes `.initial` or `.failure`
    ///     fetch(completion: { $0(completion) })
    ///
    func callAsFunction(_ change: @escaping (ChangeResult<Success, Failure>) -> Void) {
        switch self {
        case .success(let item):
            change(.initial(item))
        case .failure(let error):
            change(.failure(error))
        }
    }
}
