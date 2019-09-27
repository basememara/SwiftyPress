//
//  Loggable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public protocol Loggable {
    func Log(verbose message: String, path: String, function: String, line: Int, context: [String: Any]?)
    func Log(debug message: String, path: String, function: String, line: Int, context: [String: Any]?)
    func Log(info message: String, path: String, function: String, line: Int, context: [String: Any]?)
    func Log(warn message: String, path: String, function: String, line: Int, context: [String: Any]?)
    func Log(error message: String, path: String, function: String, line: Int, context: [String: Any]?)
}
