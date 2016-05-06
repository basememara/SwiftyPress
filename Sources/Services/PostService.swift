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

public struct PostService: Serviceable {

    public init() {
        JSON.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }

    public func get(handler: [Postable] -> Void) {
        Alamofire.request(Router.ReadPosts()).responseJASON { response in
            guard let json = response.result.value where response.result.isSuccess
                else { return }
            
            handler(json.flatMap(Post.init).flatMap { $0 as Postable })
        }
    }
    
    
    /*public lazy var allURL: String {
        return "\(baseUrl)/wp-json/posts?filter[posts_per_page]=50&filter[orderby]=modified&filter[order]=desc&page=1"
    }
    
    public lazy var popularURL: String {
        return "\(baseUrl)/wp-json/popular_count"
    }
    
    public lazy var commentsCountURL: String {
        return "\(baseUrl)/wp-json/comments_count"
    }
    
    public func get(enableCache: Bool = true, handler: ((items: [(id: Int, title: String, read: Bool)]) -> Void)? = nil) {
        let cacheParam = enableCache ? NSDate().stringFromFormat("yyyyMMdd") : "\(NSDate().timeIntervalSince1970)"
        var items: [(id: Int, title: String, read: Bool)] = []
        
        // Get data from remote server for new updates
        Alamofire.request(.GET, allURL + "&cache=\(cacheParam)")
            .response { (request, response, data, error) in
                // Handle errors if applicable
                if error != nil {
                    NSLog("Error: \(error)")
                } else {
                    items = self.store(data)
                }
                
                if let handler = handler {
                    handler(items: items)
                }
        }
    }
    
    private func store(data: NSData?) -> [(id: Int, title: String, read: Bool)] {
        var items: [(id: Int, title: String, read: Bool)] = []
        
        if let data = data {
            for (key: String, item: JSON) in JSON(data: data) {
                var hasChanges = false
                if let entity = BlogPostEntity.fromJSON(item, &hasChanges) where hasChanges {
                    // BUG: Tuples aren't appended unless using some workaround
                    // http://stackoverflow.com/questions/26076227/how-to-append-a-tuple-to-an-array-object-in-swift-code
                    items.append([(id: Int(entity.id), title: entity.title!, read: entity.read)][0])
                }
            }
            
            if items.count > 0 {
                ZamzamDataContext.sharedInstance.save()
            }
        }
        
        return items
    }
    
    public func populatePopular(enableCache: Bool = true, completion: (() -> Void)? = nil) {
        let cacheParam = enableCache ? NSDate().stringFromFormat("yyyyMMdd") : "\(NSDate().timeIntervalSince1970)"
        
        // Get data from remote server
        Alamofire.request(.GET, getPopularUrl + "?cache=\(cacheParam)")
            .response { (request, response, data, error) in
                // Handle errors if applicable
                if error != nil {
                    NSLog("Error: \(error)")
                } else if let data = data {
                    var updateCount = 0
                    
                    for (key: String, item: JSON) in JSON(data: data) {
                        if let id = item["ID"].string?.toInt(),
                            var entity = ZamzamDataContext.sharedInstance.blogPosts.first({ $0.id == Int32(id) }) {
                                let commentsCount = Int32(item["comments_count"].string?.toInt() ?? 0)
                                let viewsCount = Int32(item["views_count"].string?.toInt() ?? 0)
                                var updated = false
                                
                                // Updated comment count
                                if entity.commentsCount < commentsCount {
                                    entity.commentsCount = commentsCount
                                    updated = true
                                }
                                
                                // Updated comment count
                                if entity.viewsCount < viewsCount {
                                    entity.viewsCount = viewsCount
                                    updated = true
                                }
                                
                                if updated {
                                    updateCount++
                                }
                        }
                    }
                    
                    if updateCount > 0 {
                        ZamzamDataContext.sharedInstance.save()
                    }
                }
                
                if let callback = completion {
                    callback()
                }
        }
    }
    
    public func getByID(id: Int) -> BlogPostEntity? {
        return ZamzamDataContext.sharedInstance.blogPosts.first { $0.id == Int32(id) }
    }
    
    public func getByURL(url: String) -> BlogPostEntity? {
        if let slug = extractSlugFromURL(url),
            let item = ZamzamDataContext.sharedInstance.blogPosts.first({ $0.slug == slug }) {
                return item
        }
        
        return nil
    }
    
    public func getCommentsCount(id: Int32, completion: (count: Int) -> Void) {
        let cacheParam = NSDate().stringFromFormat("yyyyMMdd")
        
        // Get data from remote server for new updates beyond seed file
        Alamofire.request(.GET, getCommentsCountUrl + "\(id)?cache=\(cacheParam)")
            .responseString { (request, response, data, error) in
                // Handle errors if applicable
                if error != nil {
                    NSLog("Error: \(error)")
                    completion(count: 0)
                } else {
                    completion(count: data?.toInt() ?? 0)
                }
        }
    }
    
    public func extractSlugFromURL(url: String) -> String? {
        var slug = url.lowercaseString
        
        // Scrub internal links
        if slug.hasPrefix(baseUrl) {
            // Extract slug portion
            slug = slug.stringByReplacingOccurrencesOfString(
                baseUrl, withString: "", options: .CaseInsensitiveSearch, range: nil)
        }
        
        // Allow only internal links from here
        if !slug.hasPrefix("http") {
            // Handle legacy permalinks
            slug = self.zamzamManager.textService
                .replaceRegEx(url, pattern: "\\d{4}/\\d{2}/\\d{2}/", replaceValue: "")
            
            // Trim ends from slashes
            slug = slug.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "/"))
            
            // Retrieve entity from storage based based on simple slug
            if !contains(slug, "/") {
                return slug
            }
        }
        
        return nil
    }*/
    
}