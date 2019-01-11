//
//  MediaStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import ZamzamKit

public protocol MediaStore {
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[MediaType], DataError>) -> Void)
}

public protocol MediaWorkerType: MediaStore {

}
