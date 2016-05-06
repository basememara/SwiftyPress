//
//  SearchViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import UIKit
import ZamzamKit

public class SearchViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    public let service = PostService()
    public var models: [Postable] = []
    public var filteredModels: [Postable] = []
    
    @IBOutlet weak var scopeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scopeView: UIView!
    
    public lazy var activityIndicator: UIActivityIndicatorView = {
        return self.setupActivityIndicator()
    }()
    
    public lazy var searchController: UISearchController = {
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
    
    /// A `nil` / empty filter string means show all results. Otherwise, show only results containing the filter.
    var filterString: String? = nil {
        didSet {
            if (filterString ?? "").isEmpty {
                filteredModels = models
            }
            else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])

                filteredModels = models.filter { filterPredicate.evaluateWithObject($0.title) }
            }

            tableView.reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        navigationItem.titleView = searchController.searchBar
    }
    
    public func loadData() {
        activityIndicator.startAnimating()
        
        service.get { models in
            self.models = models
            self.filteredModels = models
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    public func updateSearchResultsForSearchController(searchController: UISearchController) {
        /*
            `updateSearchResultsForSearchController(_:)` is called when the controller is
            being dismissed to allow those who are using the controller they are search
            as the results controller a chance to reset their state. No need to update
            anything if we're being dismissed.
        */
        guard searchController.active else { return }
        
        filterString = searchController.searchBar.text
    }

    // MARK: UISearchBarDelegate

    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("The custom search bar keyboard search button was tapped: \(searchBar).")
        
        searchBar.resignFirstResponder()
    }
    
    public func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        filterString = nil
        searchBar.resignFirstResponder()
    }

    public func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        if AppGlobal.userDefaults[.searchHistory].isEmpty {
            return alert("No search history yet")
        }
        
        performSegueWithIdentifier(HistoryViewController.segueIdentifier, sender: nil)
    }
    
    public func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    
        return true
    }
    
    public func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        if let text = searchBar.text
            where !AppGlobal.userDefaults[.searchHistory].contains(text) {
                AppGlobal.userDefaults[.searchHistory].append(text)
        }
        
        return true
    }

    @IBAction func scopeSegmentedControlChanged(sender: UISegmentedControl) {
    
    }
    
    // MARK: UITableViewControllerDelegate
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModels.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        let model = filteredModels[indexPath.row]
        
        cell.textLabel?.text = model.title.decodeHTML()
        cell.detailTextLabel?.text = model.categories
            .map { $0.name.decodeHTML() }
            .joinWithSeparator(", ")
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(PostDetailViewController.segueIdentifier, sender: nil)
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch (segueIdentifier, segue.destinationViewController) {
            case (PostDetailViewController.segueIdentifier, let controller as PostDetailViewController):
                // Set post detail
                guard let row = tableView.indexPathForSelectedRow?.row else { break }
                controller.model = filteredModels[row]
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