//
//  Dateable.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-29.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

public protocol Dateable {
    var createdAt: Date { get }
    var modifiedAt: Date { get }
}
