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

public struct PostService {

    fileprivate enum Router: URLRequestConvertible {
        case readPost(Int)
        case readPosts(Int, Int, String, Bool)
        case commentCount(Int)
        case commentsCount
        
        static let baseURLString = AppGlobal.userDefaults[.baseURL]

        var method: HTTPMethod {
            switch self {
            case .readPost: return .get
            case .readPosts: return .get
            case .commentCount: return .get
            case .commentsCount: return .get
            }
        }

        var path: String {
            switch self {
            case .readPost(let id):
                return "/posts/\(id)"
            case .readPosts(_, _, _, _):
                return "/posts"
            case .commentCount(let id):
                return ("/comments/\(id)/count")
            case .commentsCount:
                return "/comments/count"
            }
        }
        func asURLRequest() throws -> URLRequest {
            let url = try Router.baseURLString.asURL()
            var urlRequest = URLRequest(url: url
                .appendingPathComponent(AppGlobal.userDefaults[.baseREST])
                .appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue

            switch self {
            case .readPosts(let page, let perPage, let orderBy, let ascending):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: ["filter": [
                    "posts_per_page": perPage,
                    "orderby": orderBy,
                    "order": ascending ? "asc" : "desc",
                    "page": page
                ]])
            case .commentsCount, .commentCount(_):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: [
                    "cache": Date().timeIntervalSince1970 as Any
                ])
            default: break
            }

            return urlRequest
        }
    }

    public init() {
        JSON.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
}

extension PostService: Serviceable {

    public func get(complete: @escaping ([Postable]) -> Void) {
        // Get database context
        guard let realm = AppGlobal.realm else { return complete([]) }
        
        let posts = realm.objects(Post.self)
        
        // Initial data seed if applicable
        if posts.isEmpty {
            // Start seeding from UI background thread
            Async.main {
                self.seedFromDisk {
                    // Refetch data from within current thread
                    let realm = try? Realm()
                    complete(realm?.objects(Post.self).map { $0 } ?? [])
                }
            }
            
            return
        }
        
        complete(posts.map { $0 })
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

    public func getRemote(_ page: Int = 1, perPage: Int = 50, orderBy: String = "date", ascending: Bool = false, handler: @escaping ([Postable]) -> Void) {
        Alamofire.request(Router.readPosts(page, perPage, orderBy, ascending))
            .responseJASON { response in
                guard let json = response.result.value, response.result.isSuccess
                    else { return }
                
                handler(json.flatMap(Post.init).flatMap { $0 as Postable })
        }
    }

    public func getRemoteCommentCount(_ id: Int, handler: @escaping (Int) -> Void) {
        Alamofire.request(Router.commentCount(id)).responseString { response in
            guard let value = response.result.value, response.result.isSuccess else {
                return handler(0)
            }
            
            handler(Int(value) ?? 0)
        }
    }
    
    public func addFavorite(_ id: Int) {
        if !AppGlobal.userDefaults[.favorites].contains(id) {
            AppGlobal.userDefaults[.favorites].append(id)
        }
    }
    
    public func removeFavorite(_ id: Int) {
        if let index = AppGlobal.userDefaults[.favorites].index(of: id) {
            AppGlobal.userDefaults[.favorites].remove(at: index)
        }
    }
    
    public func toggleFavorite(_ id: Int) {
        if AppGlobal.userDefaults[.favorites].contains(id) {
            removeFavorite(id)
        } else {
            addFavorite(id)
        }
    }
    
    public func updateFromRemote() {
        Alamofire.request(Router.readPosts(1, 50, "modified", false))
            .responseJASON { response in
                guard let realm = try? Realm(),
                    let json = response.result.value, response.result.isSuccess
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
        seedFromDisk(complete: nil)
    }
    
    public func seedFromDisk(complete: (() -> Void)?) {
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
        JSON(data).flatMap(Post.init).forEach { item in
            // Persist object to database
            realm.add(item, update: true)
        }
            
        do {
            try realm.commitWrite()
            
            // Recursively collect all files
            seedFromDisk(page + 1, complete: complete)
        } catch {
            // Log error and do something
            complete?()
        }
    }
    
}
