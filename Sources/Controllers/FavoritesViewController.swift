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
        
        applyFavoriteFilter()
    }
    
    func applyFavoriteFilter(reload: Bool = true) {
        let favorites = AppGlobal.userDefaults[.favorites]
            .map(String.init)
            .joinWithSeparator(",")
        
        applyFilterAndSort(filter: "id IN {\(favorites)}", reload: reload)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppGlobal.userDefaults[.favorites].count
    }
        
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let model = models?[indexPath.row] where editingStyle == .Delete {
            service.removeFavorite(model.id)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            applyFavoriteFilter(false)
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return models?.count ?? 0 == 0 ? "No favorites to show." : nil
    }
}
