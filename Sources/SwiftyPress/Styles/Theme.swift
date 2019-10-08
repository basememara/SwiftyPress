//
//  Theme.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

public protocol Theme {
    var tint: UIColor { get }
    var secondaryTint: UIColor { get }
    
    var backgroundColor: UIColor { get }
    var secondaryBackgroundColor: UIColor { get }
    var tertiaryBackgroundColor: UIColor { get }
    var quaternaryBackgroundColor: UIColor { get }
    
    var separatorColor: UIColor { get }
    var opaqueColor: UIColor { get }
    
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var tertiaryLabelColor: UIColor { get }
    var quaternaryLabelColor: UIColor { get }
    var placeholderLabelColor: UIColor { get }
    
    var buttonCornerRadius: CGFloat { get }
    
    var positiveColor: UIColor { get }
    var negativeColor: UIColor { get }
    
    var isDarkStyle: Bool { get }
    
    func apply()
    
    #if os(iOS)
    func apply(for application: UIApplication?)
    #endif
}

public extension Theme {
    
    #if os(iOS)
    var statusBarStyle: UIStatusBarStyle {
        isDarkStyle ? .lightContent : .default
    }
    
    var barStyle: UIBarStyle {
        isDarkStyle ? .black : .default
    }
    
    var keyboardAppearance: UIKeyboardAppearance {
        isDarkStyle ? .dark : .default
    }
    
    func apply() {
        apply(for: nil)
    }
    #endif
}
