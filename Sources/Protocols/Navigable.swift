//
//  Routable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/13/16.
//
//

import Foundation
import SafariServices

public protocol Navigable {

    var window: UIWindow? { get set }
}

extension Navigable {

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
    func toSearch(_ query: String) -> Bool {
        guard let controller = getRootViewByTab(3) as? SearchViewController else { return false }
        
        // Run on main UI thread in case too soon
        DispatchQueue.main.async {
            controller.applySearch(query)
        }
        
        return true
    }

    /**
     Navigates to the home tab with the category selected.

     - parameter id: The ID of the category.

     - returns: True if the navigation was successful, otherwise false.
     */
    func toTerm(_ id: Int) -> Bool {
        guard let controller = getRootViewByTab(2) as? ExploreViewController else { return false }
        
        // Run on main UI thread in case too soon
        DispatchQueue.main.async {
            controller.categoryID = id
        }
        
        return true
    }
    
    /**
     Navigates to the post detail view.

     - parameter id: The URL of the post.

     - returns: True if the navigation was successful, otherwise false.
     */
    func toPost(_ url: URL) -> Bool {
        guard let navigationController = getRootNavigationByTab(2),
            let post = PostService().get(url)
                else { return false }
            
        // Push post detail view
        let storyboard = UIStoryboard(name: "PostDetail", bundle: Bundle(for: PostDetailViewController.self))
        guard let detailController = storyboard
            .instantiateViewController(withIdentifier: "PostDetailViewController") as? PostDetailViewController
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
    func navigateByURL(_ url: URL) -> Bool {
        // Get root container and extract path from URL if applicable
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return false }
        
        // Handle url if applicable
        if url.path.isEmpty || url.path == "/" {
            // Handle search if applicable
            if let query = urlComponents.queryItems?.first(where: { $0.name == "s" })?.value {
                return toSearch(query)
            }
            
            return toHome()
        } else if let term = TermService().get(url) {
            return toTerm(term.id)
        } else if toPost(url) {
            return true
        } else {
            // Failed so open in Safari as fallback
            guard let destination = URL(string: urlComponents.addOrUpdateQueryStringParameter("mobileembed", value: "1")) else { return false }
            
            // Display browser if post not found
            getRootNavigationByTab(2)?.pushViewController(
                SFSafariViewController(url: destination), animated: false)
            
            return true
        }
    }
}

extension Navigable {

    /**
     Get the navigation controller responsible for the tab.

     - parameter index: The tab of the app.

     - returns: The navigation controller of the requested tab.
     */
    func getRootNavigationByTab(_ index: Int) -> UINavigationController? {
        // Get root tab bar controller
        guard let tabBarController = window?.rootViewController as? UITabBarController else { return nil }
        
        tabBarController.dismiss(animated: false, completion: nil)
        
        // Select tab
        tabBarController.selectedIndex = index
        
        // Get root navigation controller of tab
        guard let navigationController = tabBarController
            .selectedViewController as? UINavigationController
                else { return nil }
        
        // Pop all views of navigation controller
        navigationController.popToRootViewController(animated: false)
        
        return navigationController
    }

    /**
     Get the root view controller of the tab

     - parameter index: The tab of the app.

     - returns: The view controller of the requested tab.
     */
    func getRootViewByTab(_ index: Int) -> UIViewController? {
        return getRootNavigationByTab(index)?.topViewController
    }
}
