//
//  Localizable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-09-07.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit

// Errors
public extension Localizable {
    static let duplicateFailureErrorMessage = Localizable(NSLocalizedString("duplicate.failure.error.message", bundle: .swiftyPress, comment: "General error for duplicate data"))
    static let nonExistentErrorMessage = Localizable(NSLocalizedString("non.existent.error.message", bundle: .swiftyPress, comment: "General error for non-existent data"))
    static let unauthorizedErrorTitle = Localizable(NSLocalizedString("unauthorized.error.title", bundle: .swiftyPress, comment: "Unauthorized alert error title"))
    static let unauthorizedErrorMessage = Localizable(NSLocalizedString("unauthorized.error.message", bundle: .swiftyPress, comment: "Unauthorized alert error message"))
    static let noInternetErrorMessage = Localizable(NSLocalizedString("no.internet.error.message", bundle: .swiftyPress, comment: "General error for no internet availability"))
    static let serverTimeoutErrorMessage = Localizable(NSLocalizedString("server.timeout.error.message", bundle: .swiftyPress, comment: "General error for server availability"))
    
    static let parseFailureErrorMessage = Localizable(NSLocalizedString("parse.failure.error.message", bundle: .swiftyPress, comment: "General parse error for data"))
    static let databaseFailureErrorMessage = Localizable(NSLocalizedString("database.failure.error.message", bundle: .swiftyPress, comment: "General database error"))
    static let cacheFailureErrorMessage = Localizable(NSLocalizedString("cache.failure.error.message", bundle: .swiftyPress, comment: "Cache storage failure even though remote succeeded"))
    static let serverFailureErrorMessage = Localizable(NSLocalizedString("server.failure.error.message", bundle: .swiftyPress, comment: "General error for server request"))
    static let badRequestErrorMessage = Localizable(NSLocalizedString("bad.request.error.message", bundle: .swiftyPress, comment: "General error for bad request"))
    static let unknownReasonErrorMessage = Localizable(NSLocalizedString("unknown.reason.error.message", bundle: .swiftyPress, comment: "General error for unknown reason"))
    
    static let genericIncompleteFormErrorMessage = Localizable(NSLocalizedString("generic.incomplete.form.error.message", bundle: .swiftyPress, comment: "Generic alert error message for incomplete form"))
}

public extension Localizable {
    static let categorySection = Localizable(NSLocalizedString("category.section", bundle: .swiftyPress, comment: "Table section header for categories"))
    static let tagSection = Localizable(NSLocalizedString("tag.section", bundle: .swiftyPress, comment: "Table section header for tags"))
    
    static func taxonomy(for name: String) -> Localizable {
        let key = "taxonomy.section.\(name.lowercased())"
        
        // Determine if localization exists
        guard let bundle: Bundle = (Bundle.main.localizedString(forKey: key, value: nil, table: nil) != key ? .main
            : Bundle.swiftyPress.localizedString(forKey: key, value: nil, table: nil) != key ? .swiftyPress
            : nil) else {
                // Fallbacck to original name capitalized
                return Localizable(name.capitalized)
        }
        
        return Localizable(NSLocalizedString(key, bundle: bundle, comment: "Table section header for custom taxonomy"))
    }
}
