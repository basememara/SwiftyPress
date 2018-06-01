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
