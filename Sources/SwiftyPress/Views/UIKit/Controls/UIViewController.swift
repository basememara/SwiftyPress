//
//  UIViewController.swift
//  SwiftyPress iOS
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import ZamzamCore
import ZamzamUI

public extension UIViewController {
    
    /**
     Open Safari view controller overlay.
     
     - parameter url: URL to display in the browser.
     - parameter theme: The style of the Safari view controller.
     */
    func present(
        safari url: String,
        theme: Theme,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        present(
            safari: url,
            barTintColor: theme.backgroundColor,
            preferredControlTintColor: theme.tint,
            animated: animated,
            completion: completion
        )
    }
}
#endif
