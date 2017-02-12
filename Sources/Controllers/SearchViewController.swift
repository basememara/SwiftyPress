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

class SearchViewController: UITableViewController, RealmControllable, Trackable {
    
    var notificationToken: NotificationToken?
    var models: Results<Post>?
    let service = PostService()
    let cellNibName: String? = nil
    
    var dataView: DataViewable {
        return tableView
    }
    
    var indexPathForSelectedItem: IndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    @IBOutlet weak var scopeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scopeView: UIView!
    
    lazy var searchController: UISearchController = {
        // Create the search controller and make it perform the results updating.
        $0.searchResultsUpdater = self
        $0.hidesNavigationBarDuringPresentation = false
        $0.dimsBackgroundDuringPresentation = false
        
        $0.searchBar.delegate = self
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.placeholder = "Search".localized
        $0.searchBar.showsBookmarkButton = true
        
        if let searchTextField = $0.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        }

        self.definesPresentationContext = true
        
        return $0
    }(UISearchController(searchResultsController: nil))
    
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
            
            applyFilterAndSort(!predicates.isEmpty
                ? predicates.joined(separator: " OR ") : nil)
            
            // Google Analytics
            trackEvent("Search", action: "Post", label: filterString)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didDataControllableLoad()
        
        navigationItem.titleView = searchController.searchBar
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.separatorColor = .darkGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage("Search")
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else { return }
        filterString = searchController.searchBar.text
    }

    // MARK: UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterString = nil
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if AppGlobal.userDefaults[.searchHistory].isEmpty {
            return presentAlert("No search history yet")
        }
        
        performSegue(withIdentifier: HistoryViewController.segueIdentifier, sender: nil)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // Append search to history if new query
        if let text = searchBar.text, !text.isEmpty
            && !AppGlobal.userDefaults[.searchHistory].contains(text) {
                AppGlobal.userDefaults[.searchHistory].append(text)
        }
        
        return true
    }
    
    func applySearch(_ text: String) {
        filterString = text
        searchController.isActive = true
        searchController.searchBar.text = text
    }
    
    @IBAction func scopeSegmentedControlChanged(_ sender: UISegmentedControl) {
        // Kick didSet
        let temp = filterString
        filterString = temp
        
        // Dismiss keyboard
        searchController.searchBar.resignFirstResponder()
    }
}

extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch (segueIdentifier, segue.destination) {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        guard let model = models?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = model.title.htmlDecoded
        cell.detailTextLabel?.text = model.categories
            .map { $0.name.htmlDecoded }
            .joined(separator: ", ")
        
        cell.textLabel?.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: PostDetailViewController.segueIdentifier, sender: nil)
    }
}
