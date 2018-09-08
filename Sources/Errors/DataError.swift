//
//  DataError.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-01.
//

public enum DataError: Error {
    case duplicateFailure
    case nonExistent
    case incomplete
    case unauthorized
    case noInternet
    case timeout
    case parseFailure(Error?)
    case databaseFailure(Error?)
    case cacheFailure(Error?)
    case networkFailure(Error?)
    case unknownReason(Error?)
}

public extension DataError {
    
    /// Get the localized description for this error
    var localizedDescription: String {
        switch self {
        case .duplicateFailure: return .localized(.duplicateFailureErrorMessage)
        case .nonExistent: return .localized(.nonExistentErrorMessage)
        case .incomplete: return .localized(.genericIncompleteFormErrorMessage)
        case .unauthorized: return .localized(.unauthorizedErrorMessage)
        case .noInternet: return .localized(.noInternetErrorMessage)
        case .timeout: return .localized(.serverTimeoutErrorMessage)
        case .parseFailure: return .localized(.parseFailureErrorMessage)
        case .databaseFailure: return .localized(.databaseFailureErrorMessage)
        case .cacheFailure: return .localized(.cacheFailureErrorMessage)
        case .networkFailure: return .localized(.networkFailureErrorMessage)
        case .unknownReason: return .localized(.unknownReasonErrorMessage)
        }
    }
}
