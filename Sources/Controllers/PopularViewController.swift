//
//  FirstViewController.swift
//  SwiftyPress Example
//
//  Created by Basem Emara on 3/27/16.
//
//

import UIKit
import ZamzamKit

class PopularViewController: RealmPostTableViewController, Trackable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryID = AppGlobal.userDefaults[.featuredCategoryID]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage("Popular posts")
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite".localized) { action, index in
            guard let model = self.models?[indexPath.row] else { return }
            
            self.service.addFavorite(model.id)
            self.tableView.setEditing(false, animated: true)
    
            // Google Analytics
            self.trackEvent("Favorite", action: "Post",
                label: model.title, value: Int(model.id))
        }
        
        favorite.backgroundColor = UIColor(rgb: AppGlobal.userDefaults[.tintColor])

        return [favorite]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        var message = "\(AppGlobal.userDefaults[.appName]) is awesome! Check out the popular posts!\n\n"
        
        models?.prefix(through: 30).forEach { item in
            message += item.link + "\n"
        }
        
        presentActivityViewController([message], barButtonItem: sender)
        
        // Google Analytics
        trackEvent("Share", action: "Popular")
    }
}
