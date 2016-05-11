//
//  FirstViewController.swift
//  SwiftyPress Example
//
//  Created by Basem Emara on 3/27/16.
//
//

import UIKit
import ZamzamKit

class PopularViewController: RealmPostTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryID = 502
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .Normal, title: "Favorite".localized) { action, index in
            if let model = self.models?[indexPath.row] {
                self.service.addFavorite(model.id)
                self.tableView.setEditing(false, animated: true)
            }
        }
        
        favorite.backgroundColor = UIColor(rgb: AppGlobal.userDefaults[.tintColor])

        return [favorite]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        var message = "\(AppGlobal.userDefaults[.appName]) is awesome! Check out the popular posts!\n\n"
        
        models?.prefix(30).forEach { item in
            message += item.link + "\n"
        }
        
        let share = [message]
        let activity = UIActivityViewController(activityItems: share, applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
}
