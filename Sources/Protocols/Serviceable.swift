//
//  Serviceable.swift
//  ZamzamKitData
//
//  Created by Basem Emara on 3/27/16.
//
//

public protocol Serviceable {
    associatedtype DataType
    
    func get(handler: [DataType] -> Void)
    func seedFromDisk()
}