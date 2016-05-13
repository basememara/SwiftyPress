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
    var prepareForUnwind: (Int -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.separatorColor = .darkGrayColor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        willTrackableAppear("Categories")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        let model = models[indexPath.row]
        
        cell.textLabel?.text = model.title
        
        if let icon = model.icon {
            cell.imageView?.image = UIImage(named: icon)?.imageWithRenderingMode(.AlwaysTemplate)
        }
        
        // Select first or previously selected item
        if model.id == selectedID {
            cell.accessoryType = .Checkmark
        }
        
        cell.selectionStyle = .None
        cell.textLabel?.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = models[indexPath.row]
        selectedID = model.id
        
        // Uncheck all rows
        tableView.visibleCells.forEach { cell in
            cell.accessoryType = .None
        }
        
        // Check selected item
        tableView.cellForRowAtIndexPath(indexPath)?
            .accessoryType = .Checkmark
        
        // Google Analytics
        trackEvent("Category", action: "Post",
            label: model.title,
            value: selectedID)
        
        dismissViewController()
    }
    
    func dismissViewController() {
        prepareForUnwind?(selectedID)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func allTapped(sender: AnyObject) {
        selectedID = 0
        dismissViewController()
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}