//
//  HistoryViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import UIKit
import ZamzamKit

class HistoryViewController: UITableViewController {
    
    static var segueIdentifier = "HistorySegue"
    
    var models: [String] {
        return AppGlobal.userDefaults[.searchHistory]
    }
    
    var prepareForUnwind: (String -> Void)? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        
        cell.textLabel?.text = model
        cell.imageView?.image = cell.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewController(models[indexPath.row])
    }
    
    func dismissViewController(selected: String) {
        prepareForUnwind?(selected)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}