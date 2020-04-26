//
//  UIImage.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIImage

public extension UIImage {
    
    /// Returns the image object associated with the specified filename.
    ///
    /// - Parameter name: Enum case for image name
    convenience init?(named name: ImageName, inBundle bundle: Bundle? = nil) {
        self.init(named: name.rawValue, inBundle: bundle)
    }
    
    enum ImageName: String {
        case placeholder
        case emptyPlaceholder = "empty-set"
        case favoriteEmpty = "favorite-empty"
        case favoriteFilled = "favorite-filled"
        case more = "more-icon"
        case comments = "comments"
        case safariShare = "safari-share"
    }
}
