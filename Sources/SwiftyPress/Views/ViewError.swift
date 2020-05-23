//
//  AppAPI.swift
//  BasemEmara
//
//  Created by Basem Emara on 2019-12-17.
//

/// Model container for global view errors.
public struct ViewError: Equatable {
    public let title: String?
    public let message: String?
    
    public init(title: String?, message: String? = nil) {
        self.title = title
        self.message = message
    }
}
