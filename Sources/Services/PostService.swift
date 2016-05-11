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
import Async

public struct PostService: Serviceable {

    private enum Router: URLRequestConvertible {
        case ReadPost(Int)
        case ReadPosts(Int, Int, String, Bool)
        case CommentCount(Int)
        case CommentsCount

        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .ReadPost(let id):
                    return ("/\(AppGlobal.userDefaults[.baseREST])/posts/\(id)", [:])
                case .ReadPosts(let page, let perPage, let orderBy, let ascending):
                    return ("/\(AppGlobal.userDefaults[.baseREST])/posts", ["filter": [
                        "posts_per_page": perPage,
                        "orderby": orderBy,
                        "order": ascending ? "asc" : "desc",
                        "page": page
                    ]])
                case .CommentCount(let id):
                    return ("/\(AppGlobal.userDefaults[.baseREST])/comments/\(id)/count", [
                        "cache": NSDate().timeIntervalSince1970
                    ])
                case .CommentsCount:
                    return ("/\(AppGlobal.userDefaults[.baseREST])/comments/count", [
                        "cache": NSDate().timeIntervalSince1970
                    ])
                }
            }()

            let URL = NSURL(string: AppGlobal.userDefaults[.baseURL])!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL

            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
    }

    public init() {
        JSON.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
}

extension PostService {

    public func get(handler: [Postable] -> Void) {
        // Get database context
        guard let realm = AppGlobal.realm else { return handler([]) }
        
        let posts = realm.objects(Post)
        
        // Initial data seed if applicable
        if posts.isEmpty {
            // Start seeding from UI background thread
            Async.main {
                self.seedFromDisk {
                    // Refetch data from within current thread
                    let realm = try? Realm()
                    handler(realm?.objects(Post).map { $0 } ?? [])
                }
            }
            
            return
        }
        
        handler(posts.map { $0 })
    }

    public func getRemote(page: Int = 1, perPage: Int = 50, orderBy: String = "date", ascending: Bool = false, handler: [Postable] -> Void) {
        Alamofire.request(Router.ReadPosts(page, perPage, orderBy, ascending))
            .responseJASON { response in
                guard let json = response.result.value where response.result.isSuccess
                    else { return }
                
                handler(json.flatMap(Post.init).flatMap { $0 as Postable })
        }
    }

    public func getRemoteCommentCount(id: Int, handler: Int -> Void) {
        Alamofire.request(Router.CommentCount(id)).responseString { response in
            guard let value = response.result.value where response.result.isSuccess else {
                return handler(0)
            }
            
            handler(Int(value) ?? 0)
        }
    }
    
    public func addFavorite(id: Int) {
        if !AppGlobal.userDefaults[.favorites].contains(id) {
            AppGlobal.userDefaults[.favorites].append(id)
        }
    }
    
    public func removeFavorite(id: Int) {
        if let index = AppGlobal.userDefaults[.favorites].indexOf(id) {
            AppGlobal.userDefaults[.favorites].removeAtIndex(index)
        }
    }
    
    public func toggleFavorite(id: Int) {
        if AppGlobal.userDefaults[.favorites].contains(id) {
            removeFavorite(id)
        } else {
            addFavorite(id)
        }
    }
    
    public func updateFromRemote() {
        Alamofire.request(Router.ReadPosts(1, 50, "modified", false))
            .responseJASON { response in
                guard let realm = try? Realm(),
                    let json = response.result.value where response.result.isSuccess
                        else { return }
                
                realm.beginWrite()
        
                // Parse JSON
                json.flatMap(Post.init).forEach { item in
                    // Persist object to database
                    realm.add(item, update: true)
                }
                    
                do {
                    try realm.commitWrite()
                } catch {
                    // Log error and do something
                }
        }
    }
    
    public func seedFromDisk() {
        seedFromDisk(nil)
    }
    
    public func seedFromDisk(handler: (() -> Void)?) {
        seedFromDisk(1, handler: handler)
    }
    
    func seedFromDisk(page: Int, handler: (() -> Void)? = nil) {
        guard let realm = AppGlobal.realm,
            let path = NSBundle.mainBundle().pathForResource("posts\(page)", ofType: "json",
                inDirectory: "\(AppGlobal.userDefaults[.baseDirectory])/data"),
            let data = try? NSData(contentsOfFile: path, options: [])
                else {
                    handler?()
                    return
                }
        
        realm.beginWrite()
        
        // Parse JSON
        JSON(data).flatMap(Post.init).forEach { item in
            // Persist object to database
            realm.add(item, update: true)
        }
            
        do {
            try realm.commitWrite()
            
            // Recursively collect all files
            seedFromDisk(page + 1, handler: handler)
        } catch {
            // Log error and do something
            handler?()
        }
    }
    
}