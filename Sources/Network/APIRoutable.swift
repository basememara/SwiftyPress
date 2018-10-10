//
//  APIRoutable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-09.
//

public protocol APIRoutable {
    func asURLRequest(constants: ConstantsType) throws -> URLRequest
}
