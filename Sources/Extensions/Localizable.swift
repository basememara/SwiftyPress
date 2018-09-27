//
//  Localizable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-09-07.
//

import ZamzamKit

// Errors
public extension Localizable {
    static let noInternetErrorMessage = Localizable(NSLocalizedString("no.internet.error.message", bundle: .swiftyPress, comment: "General error for no internet availability"))
    static let serverTimeoutErrorMessage = Localizable(NSLocalizedString("server.timeout.error.message", bundle: .swiftyPress, comment: "General error for server availability"))
    static let badNetworkRequestErrorMessage = Localizable(NSLocalizedString("bad.network.request.error.message", bundle: .swiftyPress, comment: "General error for bad network request"))
    static let networkFailureErrorMessage = Localizable(NSLocalizedString("network.failure.error.message", bundle: .swiftyPress, comment: "General error for network server"))
    static let parseFailureErrorMessage = Localizable(NSLocalizedString("parse.failure.error.message", bundle: .swiftyPress, comment: "General parse error for data"))
    static let unknownReasonErrorMessage = Localizable(NSLocalizedString("unknown.reason.error.message", bundle: .swiftyPress, comment: "General error for unknown reason"))
    
    static let duplicateFailureErrorMessage = Localizable(NSLocalizedString("duplicate.failure.error.message", bundle: .swiftyPress, comment: "General error for duplicate data"))
    static let nonExistentErrorMessage = Localizable(NSLocalizedString("non.existent.error.message", bundle: .swiftyPress, comment: "General error for non-existent data"))
    static let unauthorizedErrorMessage = Localizable(NSLocalizedString("unauthorized.error.message", bundle: .swiftyPress, comment: "Unauthorized alert error message"))
    static let genericIncompleteFormErrorMessage = Localizable(NSLocalizedString("generic.incomplete.form.error.message", bundle: .swiftyPress, comment: "Generic alert error message for incomplete form"))
    static let databaseFailureErrorMessage = Localizable(NSLocalizedString("database.failure.error.message", bundle: .swiftyPress, comment: "General database error"))
    static let cacheFailureErrorMessage = Localizable(NSLocalizedString("cache.failure.error.message", bundle: .swiftyPress, comment: "Cache storage failure even though remote succeeded"))
}

public extension Localizable {
    static let categorySection = Localizable(NSLocalizedString("category.section", bundle: .swiftyPress, comment: "Table section header for categories"))
    static let tagSection = Localizable(NSLocalizedString("tag.section", bundle: .swiftyPress, comment: "Table section header for tags"))
}
