//
//  Routable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/13/16.
//
//

import Foundation
import SafariServices

public protocol Routable {

    var window: UIWindow? { get set }
}

extension Routable {

    /**
     Navigates to the home tab
     */
    func toHome() -> Bool {
        return getRootViewByTab(2) != nil
    }
    
    /**
     Navigates to the search with a query applied.

     - parameter query: The query to search.

     - returns: True if the navigation was successful, otherwise false.
     */
    func toSearch(query: String) -> Bool {
        guard let controller = getRootViewByTab(3) as? SearchViewController
            else { return false }
        
        controller.performRestoration({
            controller.applySearch(query)
        })
        
        return true
    }

    /**
     Navigates to the home tab with the category selected.

     - parameter id: The ID of the category.

     - returns: True if the navigation was successful, otherwise false.
     */
    func toTerm(id: Int) -> Bool {
        guard let controller = getRootViewByTab(2) as? ExploreViewController
            else { return false }
        
        controller.performRestoration({
            controller.categoryID = id
        })
        
        return true
    }
    
    /**
     Navigates to the post detail view.

     - parameter id: The URL of the post.

     - returns: True if the navigation was successful, otherwise false.
     */
    func toPost(url: NSURL) -> Bool {
        guard let navigationController = getRootNavigationByTab(2),
            let post = PostService().get(url)
                else { return false }
            
        // Push post detail view
        let storyboard = UIStoryboard(name: "PostDetail", bundle: NSBundle(forClass: PostDetailViewController.self))
        guard let detailController = storyboard
            .instantiateViewControllerWithIdentifier("PostDetailViewController") as? PostDetailViewController
                else { return false }
        
        detailController.model = post
        detailController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailController, animated: false)
        
        return true
    }
    
    /**
     Navigates to the view by URL

     - parameter url: URL requested.

     - returns: True if the navigation was successful, otherwise false.
     */
    func navigateByURL(url: NSURL?) -> Bool {
        // Get root container and extract path from URL if applicable
        guard let url = url,
            let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
                else { return false }
        
        // Handle url if applicable
        if url.path?.isEmpty ?? true || url.path == "/" {
            // Handle search if applicable
            if let query = urlComponents.queryItems?.first({ $0.name == "s" })?.value {
                return toSearch(query)
            }
            
            return toHome()
        } else if let term = TermService().get(url) {
            return toTerm(term.id)
        } else if toPost(url) {
            return true
        } else {
            // Failed so open in Safari as fallback
            let urlString = urlComponents.addOrUpdateQueryStringParameter("mobileembed", value: "1")
                ?? AppGlobal.userDefaults[.baseURL]
            
            // Display browser if post not found
            getRootNavigationByTab(2)?.pushViewController(
                SFSafariViewController(URL: NSURL(string: urlString)!), animated: false)
            
            return true
        }
    }
}

extension Routable {

    /**
     Get the navigation controller responsible for the tab.

     - parameter index: The tab of the app.

     - returns: The navigation controller of the requested tab.
     */
    func getRootNavigationByTab(index: Int) -> UINavigationController? {
        // Get root tab bar controller
        guard let tabBarController = window?.rootViewController as? UITabBarController
                else { return nil }
        
        tabBarController.dismissViewControllerAnimated(false, completion: nil)
        
        // Select tab
        tabBarController.selectedIndex = index
        
        // Get root navigation controller of tab
        guard let navigationController = tabBarController
            .selectedViewController as? UINavigationController
                else { return nil }
        
        // Pop all views of navigation controller
        navigationController.popToRootViewControllerAnimated(false)
        
        return navigationController
    }

    /**
     Get the root view controller of the tab

     - parameter index: The tab of the app.

     - returns: The view controller of the requested tab.
     */
    func getRootViewByTab(index: Int) -> UIViewController? {
        return getRootNavigationByTab(index)?.topViewController
    }
}