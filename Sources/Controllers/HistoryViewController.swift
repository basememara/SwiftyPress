//
//  HistoryViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import UIKit
import ZamzamKit

public class HistoryViewController: UITableViewController {
    
    public static var segueIdentifier = "HistorySegue"
    
    public var models: [String] {
        return AppGlobal.userDefaults[.searchHistory]
    }
    
    var prepareForUnwind: (String -> Void)? = nil
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        let model = models[indexPath.row]
        
        cell.textLabel?.text = model
        cell.imageView?.image = cell.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate)
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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