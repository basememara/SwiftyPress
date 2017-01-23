//
//  Serviceable.swift
//  ZamzamKitData
//
//  Created by Basem Emara on 3/27/16.
//
//

protocol Serviceable {
    associatedtype DataType
    
    func get(complete: @escaping ([DataType]) -> Void)
    func updateFromRemote()
}
