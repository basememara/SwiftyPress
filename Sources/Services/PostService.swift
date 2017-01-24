//
//  BlogPostManager.swift
//  Pods
//
//  Created by Basem Emara on 6/9/15.
//
//

import Foundation
import Alamofire
import JASON
import RealmSwift
import ZamzamKit

public struct PostService: Serviceable {

}

extension PostService {

    public func get(complete: @escaping ([Postable]) -> Void) {
        complete(AppGlobal.realm?.objects(Post.self).map { $0 } ?? [])
    }
    
    /**
     Get post by url by extracting slug.

     - parameter url: URL of the post.

     - returns: Post matching the extracted slug from the URL.
     */
    public func get(_ url: URL?) -> Post? {
        guard let url = url else { return nil }
        
        let slug = url.path.lowercased()
            .replaceRegEx("\\d{4}/\\d{2}/\\d{2}/", replaceValue: "") // Handle legacy permalinks
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            
        return AppGlobal.realm?.objects(Post.self).filter("slug == '\(slug)'").first
    }
}

extension PostService {
    
    public func addFavorite(_ id: Int) {
        guard !AppGlobal.userDefaults[.favorites].contains(id) else { return }
        AppGlobal.userDefaults[.favorites].append(id)
    }
    
    public func removeFavorite(_ id: Int) {
        guard let index = AppGlobal.userDefaults[.favorites].index(of: id) else { return }
        AppGlobal.userDefaults[.favorites].remove(at: index)
    }
    
    public func toggleFavorite(_ id: Int) {
        guard AppGlobal.userDefaults[.favorites].contains(id) else { return addFavorite(id) }
        removeFavorite(id)
    }
    
}

extension PostService {

    public func getFromRemote(id: Int, complete: @escaping (Postable) -> Void) {
        Alamofire.request(PostRouter.readPost(id))
            .responseJASON { response in
                guard let json = response.result.value, response.result.isSuccess else { return }
                complete(Post(json: json))
        }
    }
    
    public func updateFromRemote(page: Int = 0, perPage: Int = 50, orderBy: String = "post_modified", ascending: Bool = false, complete: ((Result<Void>) -> Void)? = nil) {
        Alamofire.request(PostRouter.readPosts(page, perPage, orderBy, false))
            .responseJASON { response in
                guard response.result.isSuccess,
                    let realm = try? Realm(),
                    let json = response.result.value,
                    !json.arrayValue.isEmpty else {
                        complete?(.failure(response.result.error ?? PressError.emptyPosts))
                        return
                    }
                
                // Parse JSON to array
                let list: [Post] = json.map(Post.init).filter {
                    // Skip if latest changes already persisted
                    if let persisted = AppGlobal.realm?.object(ofType: Post.self, forPrimaryKey: $0.id),
                        let localDate = persisted.modified,
                        let remoteDate = $0.modified,
                        localDate >= remoteDate {
                            return false
                    }
                
                    return true
                }
                
                if !list.isEmpty {
                    do {
                        try realm.write {
                            realm.add(List(list), update: true)
                        }
                    } catch {
                        // TODO: Log error
                    }
                }
                
                complete?(.success())
            }
    }
    
    func seedFromRemote(for page: Int = 0, complete: (() -> Void)? = nil) {
        updateFromRemote(page: page, orderBy: "post_date") {
            guard $0.isSuccess else { complete?(); return }
            self.seedFromRemote(for: page + 1, complete: complete)
        }
    }
    
}
