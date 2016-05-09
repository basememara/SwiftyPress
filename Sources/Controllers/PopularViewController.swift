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
                do {
                    try self.realm?.write {
                        model.favorite = true
                    }
                } catch {
                    // TODO: Log error
                }
            }
        }
        
        favorite.backgroundColor = UIColor(rgb: AppGlobal.userDefaults[.tintColor])

        return [favorite]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
