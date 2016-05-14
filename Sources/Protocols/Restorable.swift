//
//  Restorable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/10/16.
//
//

import Foundation
import ZamzamKit

protocol Restorable: class {
    var restorationHandlers: [() -> Void] { get set }
}

extension Restorable where Self: UIViewController {

    func willRestorableAppear() {
        // Execute any awaiting tasks
        restorationHandlers.removeEach{
            handler in handler()
        }
    }
    
    func performRestoration(handler: () -> Void) {
        // Execute process in the right lifecycle
        if isViewLoaded() {
            handler()
        } else {
            // Delay execution until view ready
            restorationHandlers.append(handler)
        }
    }
}