//
//  Social.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL

public enum Social: String {
    case twitter
    case linkedIn
    case github
    case pinterest
    case instagram
}

public extension Social {
    
    /// Web address to the social network profile
    ///
    /// - Parameter username: The profile username used for the path.
    /// - Returns: Constructed web address.
    func link(for username: String) -> String {
        switch self {
        case .twitter:
            return "https://twitter.com/\(username)"
        case .linkedIn:
            return "https://www.linkedin.com/in/\(username)"
        case .github:
            return "https://github.com/\(username)"
        case .pinterest:
            return "http://pinterest.com/\(username)"
        case .instagram:
            return "http://instagram.com/\(username)"
        }
    }
}

public extension Social {
    
    /// URL scheme to the social network app profile
    ///
    /// - Parameter username: The profile username used for the path.
    /// - Returns: Constructed URL scheme.
    func shortcut(for username: String) -> URL? {
        switch self {
        case .twitter:
            return URL(string: "twitter://user?screen_name=\(username)")
        case .linkedIn:
            return URL(string: "linkedin://profile/\(username)")
        case .github:
            return nil
        case .pinterest:
            return URL(string: "pinterest://user/\(username)")
        case .instagram:
            return URL(string: "instagram://user?username=\(username)")
        }
    }
}
