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

class PostDetailViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate, StatusBarrable, Trackable {
    
    static var segueIdentifier = "PostDetailSegue"
    static var detailTemplateFile = "post.html"
    
    var model: Post!
    var service = PostService()
    var statusBar: UIView?
    var history: [Post] = []
    
    lazy var favoriteBarButton: UIBarButtonItem = {
        return UIBarButtonItem(imageName: "star",
            target: self,
            action: #selector(favoriteTapped),
            bundleIdentifier: AppConstants.bundleIdentifier)
    }()
    
    lazy var commentBarButton: UIBarButtonItem = {
        return UIBarButtonItem(badge: nil,
            image: UIImage(named: "comments", inBundle: AppConstants.bundle)!
                .withRenderingMode(.alwaysTemplate),
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
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        
        self.view.addSubview(webView)
        
        return webView
    }()
    
    /// Template used to bind data
    lazy var template: Template? = {
        // Retrieve text from template
        guard let templateString = Bundle.stringOfFile(
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
            navigationController?.toolbar.barStyle = .black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
        // Display and update toolbar
        navigationController?.isToolbarHidden = false
        navigationController?.hidesBarsOnSwipe = true
        
        // Status bar background transparent by default so fill in
        toggleStatusBar(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.hidesBarsOnSwipe = false
        removeStatusBar()
    }
}

// MARK: - Post functions
extension PostDetailViewController {

    func loadData(_ model: Post? = nil) {
        // Store model if applicable
        if model != nil {
            self.model = model
        }
        
        // Update toolbar
        navigationController?.setNavigationBarHidden(false, animated: true)
        refreshFavoriteIcon()
        refreshCommentIcon()
        
        // Render template to web view
        webView.loadHTMLString(loadTemplate(), baseURL:
            URL(string: AppGlobal.userDefaults[.baseURL]))
        
        trackPage("Post detail - \(self.model.title.htmlDecoded)")
    }
    
    func loadTemplate() -> String {
        guard let template = template else { return model.content }
        
        // Use local stylesheet if offline
        let style = SCNetworkReachability.isOnline
            ? "<link rel='stylesheet' href='\(AppGlobal.userDefaults[.styleSheet])' type='text/css' media='all' />"
            : "<style>" + (Bundle.stringOfFile("style.css",
                inDirectory: AppGlobal.userDefaults[.baseDirectory]) ?? "") + "</style>"
        
        do {
            // Construct model for template
            var params = [
                "title": model.title,
                "content": model.content,
                "date": model.date?.dateString(in: .medium) ?? "",
                "categories": model.categories.flatMap({ item in
                    "<a href='\(AppGlobal.userDefaults[.baseURL])/category/\(item.slug)'>\(item.name)</a>"
                }).joined(separator: ", "),
                "tags": model.tags.flatMap({ item in item.name }).joined(separator: ", "),
                "isAffiliate": true,
                "style": style
            ] as [String : Any]
            
            if let author = model.author, !author.content.isEmpty {
                params["author"] = author
            }
            
            // Bind data to template
            return try template.render(params)
        } catch {
            // Error returns raw unformatted content
            return model.content
        }
    }
    
    func routeToTerm(_ id: Int) -> Bool {
        // Get root tab controller
        guard let tabBarController = UIApplication.shared
            .keyWindow?.rootViewController as? UITabBarController
                else { return false }
        
        // Remove current post detail view from stack and select another view
        if tabBarController.selectedIndex == 2 {
            _ = navigationController?.popViewController(animated: true)
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
        selectedNavController.popToRootViewController(animated: false)
        
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
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Start the network activity indicator when the web view is loading
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
  
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Stop the network activity indicator when the loading finishes
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Handle links
        if navigationAction.navigationType == .linkActivated && navigationAction.targetFrame?.isMainFrame == true {
            // Open same domain links within app
            if navigationAction.request.url?.host == URL(string: AppGlobal.userDefaults[.baseURL])?.host {
                // Deep link to category
                if let term = TermService().get(navigationAction.request.url), routeToTerm(term.id) {
                    return decisionHandler(.cancel)
                } else if let post = service.get(navigationAction.request.url) {
                    // Save history and bind retrieved post to current view
                    history.append(model)
                    loadData(post)
                    return decisionHandler(.cancel)
                }
            } else if let url = navigationAction.request.url {
                // Open external links in browser
                presentSafariController(url.absoluteString)
                return decisionHandler(.cancel)
            }
            
            // Navigating away from post so keep in history
            history.append(model)
        }
        
        decisionHandler(.allow)
    }
  
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Open "target=_blank" in the same view
        if navigationAction.targetFrame == nil {
            // Open same domain links within app
            if navigationAction.request.url?.host == URL(string: AppGlobal.userDefaults[.baseURL])?.host {
                // Deep link to category
                if let term = TermService().get(navigationAction.request.url), routeToTerm(term.id) {
                    return nil
                } else if let post = service.get(navigationAction.request.url) {
                    // Save history and bind retrieved post to current view
                    history.append(model)
                    loadData(post)
                    return nil
                }
                
                webView.load(navigationAction.request)
            } else if let url = navigationAction.request.url {
                // Open external links in browser
                presentSafariController(url.absoluteString)
                return nil
            }
            
            // Navigating away from post so keep in history
            history.append(model)
        }
        
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Display navigation/toolbar when scrolled to the bottom
        guard scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
}

// MARK: - Toolbar functions
extension PostDetailViewController {

    func loadToolbar() {
        // Add toolbar buttons
        toolbarItems = [
            UIBarButtonItem(imageName: "back", target: self, action: #selector(backTapped), bundleIdentifier: AppConstants.bundleIdentifier),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(imageName: "related", target: self, action: #selector(relatedTapped), bundleIdentifier: AppConstants.bundleIdentifier),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            commentBarButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            favoriteBarButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped(_:)))
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
        
        service.getFromRemote(id: model.id) { response in
            // Validate if not changed
            guard self.model.commentCount != response.commentCount else { return }
            
            self.commentBarButton.badgeString = "\(response.commentCount)"
            
            do {
                // Persist latest comment count
                try AppGlobal.realm?.write {
                    self.model.commentCount = response.commentCount
                }
            } catch {
                // TODO: Log error
            }
        }
    }
    
    func shareTapped(_ sender: UIBarButtonItem) {
        guard let link = URL(string: model.link) else { return }
        
        let safariActivity = UIActivity.create("Open in Safari",
            imageName: "safari-share",
            imageBundle: ZamzamConstants.bundle) {
                if !SCNetworkReachability.isOnline {
                    return self.presentAlert("Device must be online to view within the browser.")
                }
                
                UIApplication.shared.open(link)
    
                // Google Analytics
                self.trackEvent("Browser", action: "Post",
                    label: self.model.title, value: Int(self.model.id))
            }
        
        presentActivityViewController([model.title.htmlDecoded, link], barButtonItem: sender,
            applicationActivities: [safariActivity])
        
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
            return presentAlert("Device must be online to view comments.")
        }
        
        presentSafariController("\(AppGlobal.userDefaults[.baseURL])/mobile-comments/?postid=\(model.id)")
            
        // Google Analytics
        trackEvent("Comment", action: "Post",
            label: model.title, value: Int(model.id))
    }
    
    func relatedTapped() {
        if !SCNetworkReachability.isOnline {
            return presentAlert("Device must be online to view related posts.")
        }
        
        var url = "\(AppGlobal.userDefaults[.baseURL])/mobile-related/?postid=\(model.id)"
        
        if !AppGlobal.userDefaults[.darkMode] {
            url += "&theme=light"
        }
        
        history.append(model)
        webView.load(URLRequest(url: URL(string: url)!))
            
        // Google Analytics
        trackEvent("Related", action: "Post",
            label: model.title, value: Int(model.id))
    }
    
    func backTapped() {
        if history.isEmpty {
            return presentAlert("No previous post in history")
        }
        
        loadData(history.popLast())
        
        // Google Analytics
        trackEvent("Back", action: "Post",
            label: model.title, value: Int(model.id))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppGlobal.userDefaults[.darkMode] ? .lightContent : .default
    }

}
