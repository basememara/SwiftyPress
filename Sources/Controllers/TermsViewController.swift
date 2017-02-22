//
//  TermsViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2/12/17.
//
//

import UIKit
import ZamzamKit
import RealmSwift
import RateLimit

class TermsViewController: UITableViewController, RealmControllable, Trackable {
    
    @IBOutlet weak var termTypeSegmentedControl: UISegmentedControl!
    
    static var segueIdentifier = "TermsSegue"
    
    var notificationToken: NotificationToken?
    var models: Results<Term>?
    let service = TermService()
    var selectedIDs = [Int]()
    var prepareForUnwind: (([Int]) -> Void)? = nil
    let cellNibName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial default of term type before loading
        termTypeSegmentedControl.selectedSegmentIndex = !selectedIDs.isEmpty
            ? (service.taxonomy(for: selectedIDs[0]) == .tag ? 1 : 0)
            : (AppGlobal.userDefaults[.defaultTagFilter] ? 1 : 0)
        
        didDataControllableLoad()
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.separatorColor = .darkGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve latest terms not more than every X hours
        _ = AppGlobal.termRefreshLimit.execute {
            service.updateFromRemote(for: .category)
            service.updateFromRemote(for: .tag)
        }
        
        trackPage(trackName)
    }
    
    @IBAction func termTypeChanged(_ sender: UISegmentedControl) {
        clearSelection()
        applyFilterAndSort()
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        clearSelection()
    }
}

extension TermsViewController {

    var filter: String? {
        var temp = "taxonomy = '\(termType.rawValue)'"
        
        switch termType {
        case .category: temp += " && parent = 0 && slug != 'uncategorized' && id != \(AppGlobal.userDefaults[.featuredCategoryID])"
        case .tag: temp += " && count > 0"
        }
        
        return temp
    }
    
    var sortProperty: String {
        return "count"
    }
    
    var termType: TaxonomyType {
        return termTypeSegmentedControl.selectedSegmentIndex == 0 ? .category : .tag
    }
    
    var trackName: String {
        return termType == .category ? "Categories" : "Tags"
    }
}

private extension TermsViewController {
    
    func dismissViewController() {
        prepareForUnwind?(selectedIDs)
        dismiss(animated: true, completion: nil)
    }
    
    func clearSelection() {
        selectedIDs.removeAll()
        
        tableView.visibleCells.forEach { 
            $0.accessoryType = .none
            $0.isSelected = false
        }
    }
}

// MARK: - Table delegate
extension TermsViewController {
    
    var indexPathForSelectedItem: IndexPath? {
        return tableView.indexPathForSelectedRow
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        guard let model = models?[indexPath.row] else { return cell }
        
        // Set title by type
        var title = "\(model.name)"
        if termType == .tag { title += " (\(model.count))" }
        cell.textLabel?.text = title
        
        // Set image by convention if exists
        if let image = UIImage(named: model.slug) {
            cell.imageView?.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            cell.imageView?.image = nil
        }
        
        // Select first or previously selected item
        if selectedIDs.contains(model.id) {
            cell.accessoryType = .checkmark
        }
        
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = models?[indexPath.row],
            let cell = tableView.cellForRow(at: indexPath)
                else { return }
        
        // Uncheck all rows if applicable
        if termType == .category {
            clearSelection()
        }
        
        selectedIDs.append(model.id)
        cell.accessoryType = .checkmark
        
        // Google Analytics
        trackEvent(trackName, action: "Post",
            label: model.slug,
            value: model.id)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard termType == .tag,
            let model = models?[indexPath.row],
            let cell = tableView.cellForRow(at: indexPath),
            let index = selectedIDs.index(where: { $0 == model.id })
                else { return }
        
        selectedIDs.remove(at: index)
        cell.accessoryType = .none
    }
}
