//
//  BlogPostManager.swift
//  Pods
//
//  Created by Basem Emara on 6/9/15.
//
//

import Foundation
import UIKit
import Alamofire
import ZamzamKit

/*public struct NotificationService: Serviceable {
    
    let zamzamManager = ZamzamManager()
    let blogPostManager = BlogPostManager()
    let baseUrl = ZamzamConfig.getValue(ZamzamDataConstants.Configuration.BASE_URL_KEY)
    
    public var getAllUrl: String {
        get {
            return "\(baseUrl)/wp-json/posts?type=z-notification&filter[posts_per_page]=50&filter[orderby]=modified&filter[order]=desc&page=1"
        }
    }
    
    public func populate(enableCache: Bool = true, completion: ((items: [(id: Int, title: String, read: Bool)]) -> Void)? = nil) {
        let cacheParam = enableCache ? NSDate().stringFromFormat("yyyyMMdd") : "\(NSDate().timeIntervalSince1970)"
        var items: [(id: Int, title: String, read: Bool)] = []
        
        // Get data from remote server for new updates beyond seed file
        Alamofire.request(.GET, getAllUrl + "&cache=\(cacheParam)")
            .response { (request, response, data, error) in
                // Handle errors if applicable
                if error != nil {
                    NSLog("Error: \(error)")
                } else {
                    items = self.store(data)
                }
                
                if let callback = completion {
                    callback(items: items)
                }
        }
    }
    
    private func store(data: NSData?) -> [(id: Int, title: String, read: Bool)] {
        var items: [(id: Int, title: String, read: Bool)] = []
        
        if let data = data {
            for (key: String, item: JSON) in JSON(data: data) {
                var hasChanges = false
                if let entity = NotificationEntity.fromJSON(item, &hasChanges) where hasChanges {
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
    
    public func getCommentsCount(id: Int32, completion: (count: Int) -> Void) {
        blogPostManager.getCommentsCount(id, completion: completion)
    }
    
    public func getByID(id: Int) -> NotificationEntity? {
        return ZamzamDataContext.sharedInstance.notifications.first { $0.id == Int32(id) }
    }
    
}*/