//
//  Loggable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-17.
//

public protocol Loggable {
    func Log(verbose message: String, path: String, function: String, line: Int)
    func Log(debug message: String, path: String, function: String, line: Int)
    func Log(info message: String, path: String, function: String, line: Int)
    func Log(warn message: String, path: String, function: String, line: Int)
    func Log(error message: String, path: String, function: String, line: Int)
}
