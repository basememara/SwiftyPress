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

public typealias RemotePostResults = (updated: [Postable], created: [Int])

public struct PostService: Serviceable {

}

public extension PostService {

    func get(complete: @escaping ([Postable]) -> Void) {
        guard let realm = try? Realm() else { return complete([]) }
        complete(realm.objects(Post.self).map { $0 })
    }
    
    /**
     Get post by url by extracting slug.

     - parameter url: URL of the post.

     - returns: Post matching the extracted slug from the URL.
     */
    func get(_ url: URL) -> Post? {
        guard let realm = try? Realm() else { return nil }
        
        let slug = url.path.lowercased()
            .replace(regex: "\\d{4}/\\d{2}/\\d{2}/", with: "") // Handle legacy permalinks
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            
        return realm.objects(Post.self).filter("slug == '\(slug)'").first
    }
}

public extension PostService {
    
    func addFavorite(_ id: Int) {
        guard !AppGlobal.userDefaults[.favorites].contains(id) else { return }
        AppGlobal.userDefaults[.favorites].append(id)
    }
    
    func removeFavorite(_ id: Int) {
        guard let index = AppGlobal.userDefaults[.favorites].index(of: id) else { return }
        AppGlobal.userDefaults[.favorites].remove(at: index)
    }
    
    func toggleFavorite(_ id: Int) {
        guard AppGlobal.userDefaults[.favorites].contains(id) else { return addFavorite(id) }
        removeFavorite(id)
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return AppGlobal.userDefaults[.favorites].contains(id)
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
    
    @discardableResult
    public func updateFromRemote(page: Int = 0, perPage: Int = 50, orderBy: String = "post_modified", ascending: Bool = false, complete: ((ZamzamKit.Result<RemotePostResults>) -> Void)? = nil) -> SessionManager {
        let manager = Alamofire.SessionManager.default
        
        manager.request(PostRouter.readPosts(page, perPage, orderBy, false))
            .responseJASON { response in
                guard response.result.isSuccess,
                    let realm = try? Realm(),
                    let json = response.result.value else {
                        complete?(.failure(response.result.error ?? PressError.general))
                        return Log(debug: "Could not retrieve posts from remote server: \(response.debugDescription)")
                    }
                
                var results: RemotePostResults = ([], [])
                guard !json.arrayValue.isEmpty else { complete?(.success(results)); return }
                
                // Parse JSON to array
                results.updated = json.map(Post.init)
                    // Order by newest post first
                    .sorted(by: >)
                    // Ignore persisted posts with no changes
                    .filter {
                        guard let persisted = realm.object(ofType: Post.self, forPrimaryKey: $0.id) else {
                            results.created.append($0.id)
                            return true
                        }
                    
                        guard let localDate = persisted.modified,
                            let remoteDate = $0.modified,
                            localDate >= remoteDate
                                else { return true }
                    
                        return false
                    }
                
                // Persist to local storage if applicable
                if !results.updated.isEmpty {
                    do {
                        guard let posts = results.updated as? [Post] else { throw PressError.parseFail }
                        try realm.write { realm.add(List(posts), update: true) }
                        Log(debug: "Posts updated from remote server: \(results.updated.count) updated items, \(results.created.count) new items.")
                    } catch {
                        complete?(.failure(PressError.databaseFail))
                        return Log(error: "Could not persist the posts: \(error).")
                    }
                }
                
                complete?(.success(results))
            }
        
        return manager
    }
    
    func seedFromRemote(for page: Int = 0, complete: (() -> Void)? = nil) {
        updateFromRemote(page: page, orderBy: "post_date") {
            guard $0.isSuccess else { complete?(); return }
            self.seedFromRemote(for: page + 1, complete: complete)
        }
    }
    
}
