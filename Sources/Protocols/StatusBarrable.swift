//
//  StatusBarable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/9/16.
//
//

import Foundation

protocol StatusBarrable: class {

    var statusBar: UIView? { get set }
}

extension StatusBarrable where Self: UIViewController {

    private func showStatusBar(_ target: UIViewController? = nil) {
        if statusBar == nil {
            statusBar = (target ?? self).addStatusBar(
                darkMode: AppGlobal.userDefaults[.darkMode])
        } else {
            statusBar?.isHidden = false
        }
    }

    private func hideStatusBar() {
        statusBar?.isHidden = true
    }

    /**
     Toggles status bar background with light or dark mode.

     - parameter enable: Display or hide status bar, otherwise toggle if nil.
     - parameter darkMode: Light or dark mode color of status bar.
     - parameter target: View controller to add status bar.
     */
    func toggleStatusBar(_ enable: Bool? = nil, target: UIViewController? = nil) {
        // Create status bar first time if applicable
        guard let statusBar = statusBar else {
            return enable ?? true
                ? showStatusBar(target)
                : hideStatusBar()
        }
        
        // Auto toggle based on current status bar state
        guard let enable = enable else {
            return statusBar.isHidden
                ? showStatusBar(target)
                : hideStatusBar()
        }
        
        return enable
            ? showStatusBar(target)
            : hideStatusBar()
    }

    func removeStatusBar() {
        statusBar?.removeFromSuperview()
        statusBar = nil
    }
}
