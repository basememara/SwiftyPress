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

class SearchViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, RealmControllable {
    
    var realm: Realm?
    var notificationToken: NotificationToken?
    var models: Results<Post>?
    let service = PostService()
    let cellNibName: String? = nil
    
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

        self.definesPresentationContext = true
        
        return searchController
    }()
    
    /// Empty filter string means show all results, otherwise show only results containing the filter.
    var filterString: String? = nil {
        didSet {
            if (filterString ?? "").isEmpty {
                //filteredModels = models
            }
            else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])

                //filteredModels = models.filter { filterPredicate.evaluateWithObject($0.title) }
            }

            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didLoad()
        
        navigationItem.titleView = searchController.searchBar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbarHidden = true
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
        searchBar.resignFirstResponder()
    }

    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        if AppGlobal.userDefaults[.searchHistory].isEmpty {
            return alert("No search history yet")
        }
        
        performSegueWithIdentifier(HistoryViewController.segueIdentifier, sender: nil)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        // Append search to history if new query
        if let text = searchBar.text where !text.isEmpty
            && !AppGlobal.userDefaults[.searchHistory].contains(text) {
                AppGlobal.userDefaults[.searchHistory].append(text)
        }
        
        return true
    }

    @IBAction func scopeSegmentedControlChanged(sender: UISegmentedControl) {
    
    }
}

extension SearchViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch (segueIdentifier, segue.destinationViewController) {
            case (PostDetailViewController.segueIdentifier, let controller as PostDetailViewController):
                // Set post detail
                guard let row = indexPathForSelectedItem?.row,
                    let model = models?[row] as? Postable else { break }
                controller.model = model
            case (HistoryViewController.segueIdentifier, let navController as UINavigationController):
                guard let controller = navController.topViewController as? HistoryViewController
                    else { break }
                    
                // Prepare to retrieve selected history
                controller.prepareForUnwind = { [unowned self] text in
                    self.filterString = text
                    self.searchController.searchBar.text = text
                    self.searchController.active = true
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
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(PostDetailViewController.segueIdentifier, sender: nil)
    }
}