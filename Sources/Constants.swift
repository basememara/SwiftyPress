//
//  Constants.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-21.
//

public protocol ConstantsType {
    var logFileName: String { get }
    var logDNAKey: String? { get }
}

public struct Constants: ConstantsType {
    public let logFileName = "swiftypress"
    public let logDNAKey: String? = nil
}
