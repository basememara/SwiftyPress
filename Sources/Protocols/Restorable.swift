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

extension Restorable {

    func willRestorableAppear() {
        // Execute any awaiting tasks
        restorationHandlers.removeEach{
            handler in handler()
        }
    }
}