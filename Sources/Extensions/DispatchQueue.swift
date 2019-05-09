//
//  DispatchQueue.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//

import Foundation

extension DispatchQueue {
    
    /// A configure queue for executing database related work items.
    static let database = DispatchQueue(label: "SwiftyPress.DispatchQueue.database", qos: .utility)
    
    /// A configure queue for executing parsing or decoding related work items.
    static let transform = DispatchQueue(label: "SwiftyPress.DispatchQueue.transform", qos: .userInitiated)
}
