//
//  FavoritesCollectionViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/3/16.
//
//

import UIKit

class FavoritesViewController: RealmPostTableViewController, Trackable {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        willTrackableAppear("Favorites")
        
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
    
    @IBAction func shareTapped(sender: AnyObject) {
        guard let models = models where models.count > 0 else {
            return alert("No favorites yet")
        }
        
        var message = "\(AppGlobal.userDefaults[.appName]) is awesome! Check out my favorite posts!\n\n"
        
        models.prefix(30).forEach { item in
            message += item.link + "\n"
        }
        
        let share = [message]
        let activity = UIActivityViewController(activityItems: share, applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
        
        // Google Analytics
        trackEvent("Share", action: "Favorites")
    }
}
