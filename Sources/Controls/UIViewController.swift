//
//  UIViewController.swift
//  SwiftyPress iOS
//
//  Created by Basem Emara on 2018-10-08.
//

import UIKit
import ZamzamKit

public extension UIViewController {
    
    /**
     Open Safari view controller overlay.
     
     - parameter url: URL to display in the browser.
     - parameter theme: The style of the Safari view controller.
     */
    func present(
        safari url: String,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        theme: Theme,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        present(
            safari: url,
            modalPresentationStyle: modalPresentationStyle,
            barTintColor: theme.backgroundColor,
            preferredControlTintColor: theme.tint,
            animated: animated,
            completion: completion
        )
    }
}
