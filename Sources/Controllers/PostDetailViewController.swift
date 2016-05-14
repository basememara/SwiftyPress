//
//  PostDetailController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 3/30/16.
//
//

import UIKit
import WebKit
import ZamzamKit
import Timepiece
import Stencil
import RealmSwift
import SystemConfiguration

class PostDetailViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, StatusBarrable, Trackable {
    
    static var segueIdentifier = "PostDetailSegue"
    static var detailTemplateFile = "post.html"
    
    var model: Post!
    var service = PostService()
    var statusBar: UIView?
    
    lazy var favoriteBarButton: UIBarButtonItem = {
        return UIBarButtonItem(imageName: "star",
            target: self,
            action: #selector(favoriteTapped),
            bundleIdentifier: AppConstants.bundleIdentifier)
    }()
    
    lazy var commentBarButton: UIBarButtonItem = {
        return UIBarButtonItem(badge: nil,
            image: UIImage(named: "comments", inBundle: AppConstants.bundle)!
                .imageWithRenderingMode(.AlwaysTemplate),
            target: self,
            action: #selector(commentsTapped),
            color: UIColor(rgb: AppGlobal.userDefaults[.secondaryTintColor]))
    }()
    
    /// Web view for display content detail
    lazy var webView: WKWebView = {
        // Create preferences on how the web page should be loaded
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        // Create a configuration for the preferences
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.UIDelegate = self
        
        self.view.addSubview(webView)
        
        return webView
    }()
    
    /// Template used to bind data
    lazy var template: Template? = {
        // Retrieve text from template
        guard let templateString = NSBundle.stringOfFile(
            PostDetailViewController.detailTemplateFile,
            inDirectory: AppGlobal.userDefaults[.baseDirectory])
                else { return nil }
        
        // Compile template
        return Template(templateString: templateString)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadToolbar()
        
        if AppGlobal.userDefaults[.darkMode] {
            navigationController?.toolbar.barStyle = .Black
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
        // Display and update toolbar
        navigationController?.toolbarHidden = false
        navigationController?.hidesBarsOnSwipe = true
        
        // Status bar background transparent by default so fill in
        toggleStatusBar(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.toolbarHidden = true
        navigationController?.hidesBarsOnSwipe = false
        removeStatusBar()
    }
}

// MARK: - Post functions
extension PostDetailViewController {

    func loadData(model: Post? = nil) {
        // Store model if applicable
        if model != nil {
            self.model = model
        }
        
        willTrackableAppear(
            "Post detail - \(self.model.title.decodeHTML())")
        // Update toolbar
        navigationController?.setNavigationBarHidden(false, animated: true)
        refreshFavoriteIcon()
        refreshCommentIcon()
        
        // Render template to web view
        webView.loadHTMLString(loadTemplate(), baseURL:
            NSURL(string: AppGlobal.userDefaults[.baseURL]))
        
    }
    
    func loadTemplate() -> String {
        guard let template = template else { return model.content }
        
        let style = SCNetworkReachability.isOnline
            ? "<link rel='stylesheet' href='\(AppGlobal.userDefaults[.styleSheet])' type='text/css' media='all' />"
            : "<style>" + (NSBundle.stringOfFile("style.css",
                inDirectory: AppGlobal.userDefaults[.baseDirectory]) ?? "") + "</style>"
        
        do {
            // Bind data to template
            return try template.render(Context(dictionary: [
                "title": model.title,
                "content": model.content,
                "date": model.date?.stringFromFormat("MMMM dd, yyyy"),
                "categories": model.categories.flatMap({ item in
                    "<a href='\(AppGlobal.userDefaults[.baseURL])/category/\(item.slug)'>\(item.name)</a>"
                }).joinWithSeparator(", "),
                "tags": model.tags.flatMap({ item in item.name }).joinWithSeparator(", "),
                "isAffiliate": true,
                "style": style
            ]))
        } catch {
            // Error returns raw unformatted content
            return model.content
        }
    }
    
    func routeToTerm(id: Int) -> Bool {
        // Get root tab controller
        guard let tabBarController = UIApplication.sharedApplication()
            .keyWindow?.rootViewController as? UITabBarController
                else { return false }
        
        // Remove current post detail view from stack and select another view
        if tabBarController.selectedIndex == 2 {
            navigationController?.popViewControllerAnimated(true)
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
            tabBarController.selectedIndex = 2
        }
        
        // Get root navigation controller of tab
        guard let selectedNavController = tabBarController
            .selectedViewController as? UINavigationController
                else { return false }
        
        // Pop all views of navigation controller
        selectedNavController.popToRootViewControllerAnimated(false)
        
        // Handle explore view and select category
        if let controller = selectedNavController.topViewController as? ExploreViewController {
            controller.performRestoration({
                controller.categoryID = id
            })
            return true
        }
        
        return false
    }
}

// MARK: - Web view functions
extension PostDetailViewController {
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Start the network activity indicator when the web view is loading
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
  
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        // Stop the network activity indicator when the loading finishes
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        // Handle links
        if navigationAction.navigationType == .LinkActivated && navigationAction.targetFrame?.mainFrame == true {
            // Open same domain links within app
            if navigationAction.request.URL?.host == NSURL(string: AppGlobal.userDefaults[.baseURL])?.host {
                // Deep link to category
                if let term = TermService().get(navigationAction.request.URL) where routeToTerm(term.id) {
                    return decisionHandler(.Cancel)
                } else if let post = service.get(navigationAction.request.URL) {
                    // Bind retrieved post to current view
                    loadData(post)
                    return decisionHandler(.Cancel)
                }
            } else {
                // Open external links in browser
                presentSafariController(navigationAction.request.URLString)
                return decisionHandler(.Cancel)
            }
        }
        
        decisionHandler(.Allow)
    }
  
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.Allow)
    }
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Open "target=_blank" in the same view
        if navigationAction.targetFrame == nil {
            // Open same domain links within app
            if navigationAction.request.URL?.host == NSURL(string: AppGlobal.userDefaults[.baseURL])?.host {
                // Deep link to category
                if let term = TermService().get(navigationAction.request.URL) where routeToTerm(term.id) {
                    return nil
                } else if let post = service.get(navigationAction.request.URL) {
                    // Bind retrieved post to current view
                    loadData(post)
                    return nil
                }
                
                webView.loadRequest(navigationAction.request)
            } else {
                // Open external links in browser
                presentSafariController(navigationAction.request.URLString)
            }
        }
        
        return nil
    }
}

// MARK: - Toolbar functions
extension PostDetailViewController {

    func loadToolbar() {
        // Add toolbar buttons
        toolbarItems = [
            UIBarButtonItem(imageName: "safari", target: self, action: #selector(browserTapped), bundleIdentifier: AppConstants.bundleIdentifier),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(imageName: "related", target: self, action: #selector(relatedTapped), bundleIdentifier: AppConstants.bundleIdentifier),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            commentBarButton,
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            favoriteBarButton,
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(shareTapped))
        ]
    }

    func refreshFavoriteIcon() {
        // Update favorite indicator
        favoriteBarButton.image = UIImage(named: AppGlobal.userDefaults[.favorites].contains(model.id)
            ? "star-filled" : "star",
                inBundle: AppConstants.bundle)
    }
    
    func refreshCommentIcon() {
        commentBarButton.badgeString = model.commentCount > 0
            ? "\(model.commentCount)" : nil
        
        service.getRemoteCommentCount(model.id) { [weak self] count in
            guard let strongSelf = self else { return }
            
            // Validate if not changed
            if strongSelf.model.commentCount == count {
                return
            }
            
            strongSelf.commentBarButton.badgeString = "\(count)"
            
            do {
                // Persist latest comment count
                try AppGlobal.realm?.write {
                    strongSelf.model.commentCount = count
                }
            } catch {
                // TODO: Log error
            }
        }
    }
    
    func shareTapped() {
        guard let link = NSURL(string: model.link) else { return }
        
        let share = [model.title.decodeHTML(), link]
        let activity = UIActivityViewController(activityItems: share, applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
        
        // Google Analytics
        trackEvent("Share", action: "Post",
            label: model.title, value: Int(model.id))
    }
    
    func favoriteTapped() {
        service.toggleFavorite(model.id)
        refreshFavoriteIcon()
    
        // Google Analytics
        trackEvent("Favorite", action: "Post",
            label: model.title, value: Int(model.id))
    }
    
    func commentsTapped() {
        if !SCNetworkReachability.isOnline {
            return alert("Device must be online to view comments.")
        }
        
        presentSafariController("\(AppGlobal.userDefaults[.baseURL])/mobile-comments/?postid=\(model.id)")
            
        // Google Analytics
        trackEvent("Comment", action: "Post",
            label: model.title, value: Int(model.id))
    }
    
    func relatedTapped() {
        if !SCNetworkReachability.isOnline {
            return alert("Device must be online to view related posts.")
        }
        
        var url = "\(AppGlobal.userDefaults[.baseURL])/mobile-related/?postid=\(model.id)"
        
        if !AppGlobal.userDefaults[.darkMode] {
            url += "&theme=light"
        }
        
        presentSafariController(url)
            
        // Google Analytics
        trackEvent("Related", action: "Post",
            label: model.title, value: Int(model.id))
    }
    
    func browserTapped() {
        if !SCNetworkReachability.isOnline {
            return alert("Device must be online to view within the browser.")
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: model.link)!)
    
        // Google Analytics
        trackEvent("Browser", action: "Post",
            label: model.title, value: Int(model.id))
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return AppGlobal.userDefaults[.darkMode] ? .LightContent : .Default
    }

}