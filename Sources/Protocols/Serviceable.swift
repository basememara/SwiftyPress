//
//  Serviceable.swift
//  ZamzamKitData
//
//  Created by Basem Emara on 3/27/16.
//
//

protocol Serviceable {
    associatedtype DataType
    
    func get(completion: @escaping ([DataType]) -> Void)
}
