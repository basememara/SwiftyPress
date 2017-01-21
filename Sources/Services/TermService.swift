//
//  TermService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/13/16.
//
//

import Foundation

public struct TermService {
    
    /**
     Get term by url by extracting slug.

     - parameter url: URL of the term.

     - returns: Term matching the extracted slug from the URL.
     */
    public func get(_ url: URL?) -> Term? {
        guard let url = url, let slug = url.pathComponents.get(2), url.pathComponents.get(1) == "category"
                 else { return nil }
            
        return AppGlobal.realm?.objects(Term.self).filter("slug == '\(slug)'").first
    }
}
