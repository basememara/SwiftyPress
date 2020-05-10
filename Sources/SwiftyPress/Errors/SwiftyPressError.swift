//
//  SwiftyPressError.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-01.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public enum SwiftyPressError: Error {
    case duplicateFailure
    case nonExistent
    case incomplete
    case unauthorized
    case noInternet
    case timeout
    case parseFailure(Error?)
    case databaseFailure(Error?)
    case cacheFailure(Error?)
    case serverFailure(Error?)
    case requestFailure(Error?)
    case unknownReason(Error?)
}

public extension SwiftyPressError {
    
    /// Get the localized description for this error
    var localizedDescription: String {
        switch self {
        case .duplicateFailure:
            return .localized(.duplicateFailureErrorMessage)
        case .nonExistent:
            return .localized(.nonExistentErrorMessage)
        case .incomplete:
            return .localized(.genericIncompleteFormErrorMessage)
        case .unauthorized:
            return .localized(.unauthorizedErrorMessage)
        case .noInternet:
            return .localized(.noInternetErrorMessage)
        case .timeout:
            return .localized(.serverTimeoutErrorMessage)
        case .parseFailure:
            return .localized(.parseFailureErrorMessage)
        case .databaseFailure:
            return .localized(.databaseFailureErrorMessage)
        case .cacheFailure:
            return .localized(.cacheFailureErrorMessage)
        case .serverFailure:
            return .localized(.serverFailureErrorMessage)
        case .requestFailure:
            return .localized(.badRequestErrorMessage)
        case .unknownReason:
            return .localized(.unknownReasonErrorMessage)
        }
    }
}
