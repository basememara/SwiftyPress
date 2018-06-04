//
//  MediaMemoryStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import ZamzamKit

public struct MediaMemoryStore: MediaStore {
    
}

public extension MediaMemoryStore {
    
    func fetch(id: Int, completion: @escaping (Result<MediaType, DataError>) -> Void) {
        let media = [
            Media(
                id: 1,
                link: "http://basememara.com/wp-content/uploads/2016/05/CapturFiles_349.png",
                width: 1428,
                height: 1060,
                thumbnailLink: "http://basememara.com/wp-content/uploads/2016/05/CapturFiles_349-500x371.png",
                thumbnailWidth: 500,
                thumbnailHeight: 371
            ),
            Media(
                id: 2,
                link: "http://basememara.com/wp-content/uploads/2018/04/swift-dependency-injection.jpg",
                width: 3569,
                height: 2899,
                thumbnailLink: "http://basememara.com/wp-content/uploads/2018/04/swift-dependency-injection-500x406.jpg",
                thumbnailWidth: 500,
                thumbnailHeight: 406
            ),
            Media(
                id: 3,
                link: "http://basememara.com/wp-content/uploads/2016/03/CapturFiles_330.png",
                width: 1218,
                height: 512,
                thumbnailLink: "http://basememara.com/wp-content/uploads/2016/03/CapturFiles_330-500x210.png",
                thumbnailWidth: 500,
                thumbnailHeight: 210
            ),
            ]
        
        guard let item = media.first(where: { $0.id == id }) else {
            return completion(.failure(.nonExistent))
        }
        
        completion(.success(item))
    }
}
