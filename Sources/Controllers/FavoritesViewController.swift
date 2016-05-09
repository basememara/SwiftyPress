//
//  FavoritesCollectionViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/3/16.
//
//

import UIKit

class FavoritesViewController: RealmPostTableViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        applyFilterAndSort(filter: "favorite == 1")
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let model = models?[indexPath.row] where editingStyle == .Delete {
            do {
                try AppGlobal.realm?.write {
                    model.favorite = false
                }
            } catch {
                // TODO: Log error
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return models?.count ?? 0 == 0 ? "No favorites to show." : nil
    }
}
