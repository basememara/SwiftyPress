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

    public func getRemote(_ page: Int = 1, perPage: Int = 50, orderBy: String = "date", ascending: Bool = false, complete: @escaping ([Postable]) -> Void) {
        Alamofire.request(PostRouter.readPosts(page, perPage, orderBy, ascending))
            .responseJASON { response in
                guard let json = response.result.value, response.result.isSuccess else { return }
                complete(json.flatMap(Post.init).flatMap { $0 as Postable })
        }
    }

    public func getRemoteCommentCount(_ id: Int, complete: @escaping (Int) -> Void) {
        Alamofire.request(PostRouter.commentCount(id)).responseString { response in
            guard let value = response.result.value, response.result.isSuccess else { return complete(0) }
            complete(Int(value) ?? 0)
        }
    }

    public func updateFromRemote() {
        Alamofire.request(PostRouter.readPosts(1, 50, "modified", false))
            .responseJASON { response in
                guard let realm = try? Realm(),
                    let json = response.result.value, response.result.isSuccess
                        else { return }
                
                realm.beginWrite()
        
                // Parse JSON
                json.flatMap(Post.init).forEach {
                    // Persist object to database
                    realm.add($0, update: true)
                }
                    
                do {
                    try realm.commitWrite()
                } catch {
                    // Log error and do something
                }
            }
    }
}

extension PostService {
    
    func seedFromDisk() {
        seedFromDisk(complete: nil)
    }
    
    func seedFromDisk(complete: (() -> Void)?) {
        seedFromDisk(1, complete: complete)
    }
    
    func seedFromDisk(_ page: Int, complete: (() -> Void)? = nil) {
        guard let realm = AppGlobal.realm,
            let path = Bundle.main.url(forResource: "posts\(page)", withExtension: "json",
                subdirectory: "\(AppGlobal.userDefaults[.baseDirectory])/data"),
            let data = try? Data(contentsOf: path)
                else { complete?(); return }
        
        realm.beginWrite()
        
        // Parse JSON
        JSON(data).flatMap(Post.init).forEach {
            // Persist object to database
            realm.add($0, update: true)
        }
            
        do {
            try realm.commitWrite()
            
            // Recursively collect all files
            self.seedFromDisk(page + 1, complete: complete)
        } catch {
            // Log error and do something
            complete?()
        }
    }
    
}
