//
//  SearchViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import UIKit
import RealmSwift
import ZamzamKit

class SearchViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, RealmControllable, Restorable, Trackable {
    
    var notificationToken: NotificationToken?
    var models: Results<Post>?
    let service = PostService()
    let cellNibName: String? = nil
    var restorationHandlers: [() -> Void] = []
    
    var dataView: DataViewable {
        return tableView
    }
    
    var indexPathForSelectedItem: NSIndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    @IBOutlet weak var scopeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scopeView: UIView!
    
    lazy var searchController: UISearchController = {
        // Create the search controller and make it perform the results updating.
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.placeholder = "Search".localized
        searchController.searchBar.showsBookmarkButton = true
        
        if let searchTextField = searchController.searchBar.valueForKey("searchField") as? UITextField {
            searchTextField.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        }

        self.definesPresentationContext = true
        
        return searchController
    }()
    
    /// Empty filter string means show all results, otherwise show only results containing the filter.
    var filterString: String? = nil {
        didSet {
            var predicates: [String] = []
            
            if !(filterString ?? "").isEmpty {
                // By title
                if scopeSegmentedControl.selectedSegmentIndex == 0
                    || scopeSegmentedControl.selectedSegmentIndex == 1 {
                        predicates.append("title CONTAINS[c] '\(filterString!)'")
                }
                
                // By content
                if scopeSegmentedControl.selectedSegmentIndex == 0
                    || scopeSegmentedControl.selectedSegmentIndex == 2 {
                        predicates.append("content CONTAINS[c] '\(filterString!)'")
                }
                
                // By keywords
                if scopeSegmentedControl.selectedSegmentIndex == 0
                    || scopeSegmentedControl.selectedSegmentIndex == 3 {
                        predicates.append("ANY categories.name CONTAINS[c] '\(filterString!)'")
                        predicates.append("ANY tags.name CONTAINS[c] '\(filterString!)'")
                }
            }
            
            applyFilterAndSort(filter: !predicates.isEmpty
                ? predicates.joinWithSeparator(" OR ") : nil)
            
            // Google Analytics
            trackEvent("Search", action: "Post", label: filterString)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didDataControllableLoad()
        
        navigationItem.titleView = searchController.searchBar
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.separatorColor = .darkGrayColor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        willRestorableAppear()
        trackPage("Search")
    }
}

extension SearchViewController {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard searchController.active else { return }
        filterString = searchController.searchBar.text
    }

    // MARK: UISearchBarDelegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        filterString = nil
    }

    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        if AppGlobal.userDefaults[.searchHistory].isEmpty {
            return alert("No search history yet")
        }
        
        performSegueWithIdentifier(HistoryViewController.segueIdentifier, sender: nil)
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        // Append search to history if new query
        if let text = searchBar.text where !text.isEmpty
            && !AppGlobal.userDefaults[.searchHistory].contains(text) {
                AppGlobal.userDefaults[.searchHistory].append(text)
        }
        
        return true
    }
    
    func applySearch(text: String) {
        filterString = text
        searchController.active = true
        searchController.searchBar.text = text
    }
    
    @IBAction func scopeSegmentedControlChanged(sender: UISegmentedControl) {
        // Kick didSet
        let temp = filterString
        filterString = temp
        
        // Dismiss keyboard
        searchController.searchBar.resignFirstResponder()
    }
}

extension SearchViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch (segueIdentifier, segue.destinationViewController) {
            case (PostDetailViewController.segueIdentifier, let controller as PostDetailViewController):
                // Set post detail
                guard let row = indexPathForSelectedItem?.row,
                    let model = models?[row] else { break }
                controller.model = model
            case (HistoryViewController.segueIdentifier, let navController as UINavigationController):
                guard let controller = navController.topViewController as? HistoryViewController
                    else { break }
                    
                // Prepare to retrieve selected history
                controller.prepareForUnwind = { text in
                    self.applySearch(text)
                }
            default: break
        }
    }
}

/// MARK: UITableViewControllerDelegate
extension SearchViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        guard let model = models?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = model.title.decodeHTML()
        cell.detailTextLabel?.text = model.categories
            .map { $0.name.decodeHTML() }
            .joinWithSeparator(", ")
        
        cell.textLabel?.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(PostDetailViewController.segueIdentifier, sender: nil)
    }
}