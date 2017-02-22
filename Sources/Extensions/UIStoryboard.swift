//
//  UIStoryboard.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2/20/17.
//
//

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case PostDetail
        case PostPreview
    }
    
    /**
     Creates and returns a storyboard object for the specified storyboard enum resource file in the main bundle of the current application.
     - parameter storyboard: The name of the storyboard resource file without the filename extension.
     - returns: A storyboard object for the specified file. If no storyboard resource file matching name exists, an exception is thrown.
     */
    convenience init(for storyboard: Storyboard, with bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
}
