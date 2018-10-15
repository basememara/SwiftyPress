//
//  SeedFileStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-12.
//

import ZamzamKit

public struct SeedFileStore: SeedStore, Loggable {
    static var data: ModifiedPayload!
    
    private var data: ModifiedPayload {
        return SeedFileStore.data
    }
    
    public init(forResource name: String, inBundle bundle: Bundle) {
        guard SeedFileStore.data == nil else { return }
        
        SeedFileStore.data = try! JSONDecoder.default.decode(
            ModifiedPayload.self,
            forResource: name,
            inBundle: bundle
        )
    }
}

public extension SeedFileStore {
    
    func fetchModified(after date: Date?, completion: @escaping (Result<ModifiedPayload, DataError>) -> Void) {
        // Return all elements if applicable
        guard let date = date else { return completion(.success(data)) }
        
        let posts = data.posts.filter { $0.modifiedAt > date }
        
        let categoryIDs = posts.flatMap { $0.categories }
        let categories = data.categories.filter { categoryIDs.contains($0.id) }
        
        let tagIDs = posts.flatMap { $0.tags }
        let tags = data.tags.filter { tagIDs.contains($0.id) }
        
        let authors = data.authors.filter { $0.modifiedAt > date }
        
        let mediaIDs = posts.compactMap { $0.mediaID }
        let media = data.media.filter { mediaIDs.contains($0.id) }
        
        // Filter for elements that have been modified by requested date
        let modifiedPayload = ModifiedPayload(
            posts: posts,
            categories: categories,
            tags: tags,
            authors: authors,
            media: media
        )
        
        completion(.success(modifiedPayload))
    }
}
