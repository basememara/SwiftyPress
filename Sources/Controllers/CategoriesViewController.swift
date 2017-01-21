//
//  SPCategoriesViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/5/16.
//
//

import UIKit

class CategoriesViewController: UITableViewController, Trackable {
    
    static var segueIdentifier = "CategorySegue"
    
    var models = CategoryService.storedItems
    var selectedID: Int = 0
    var prepareForUnwind: ((Int) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.separatorColor = .darkGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage("Categories")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        let model = models[indexPath.row]
        
        cell.textLabel?.text = model.title
        
        if let icon = model.icon {
            cell.imageView?.image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
        }
        
        // Select first or previously selected item
        if model.id == selectedID {
            cell.accessoryType = .checkmark
        }
        
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        selectedID = model.id
        
        // Uncheck all rows
        tableView.visibleCells.forEach { cell in
            cell.accessoryType = .none
        }
        
        // Check selected item
        tableView.cellForRow(at: indexPath)?
            .accessoryType = .checkmark
        
        // Google Analytics
        trackEvent("Category", action: "Post",
            label: model.title,
            value: selectedID)
        
        dismissViewController()
    }
    
    func dismissViewController() {
        prepareForUnwind?(selectedID)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allTapped(_ sender: AnyObject) {
        selectedID = 0
        dismissViewController()
    }
    
    @IBAction func closeTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
