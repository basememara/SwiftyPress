//
//  FavoritesCollectionViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/3/16.
//
//

import UIKit

class FavoritesViewController: RealmPostTableViewController, Trackable {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyFavoriteFilter()
        trackPage("Favorites")
    }
    
    func applyFavoriteFilter(_ reload: Bool = true) {
        let favorites = AppGlobal.userDefaults[.favorites]
            .map(String.init)
            .joined(separator: ",")
        
        applyFilterAndSort("id IN {\(favorites)}", reload: reload)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppGlobal.userDefaults[.favorites].count
    }
        
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let model = models?[indexPath.row], editingStyle == .delete {
            service.removeFavorite(model.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
            applyFavoriteFilter(false)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return models?.count ?? 0 == 0 ? "No favorites to show." : nil
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        guard let models = models, !models.isEmpty else {
            return presentAlert("No favorites yet")
        }
        
        let posts = models.prefix(30)
        let message = "\(AppGlobal.userDefaults[.appName]) is awesome! Check out my favorite posts!\n\n"
            + posts.map { $0.link }.joined(separator: "\n\n")
        
        presentActivityViewController([message], barButtonItem: sender)
        
        // Google Analytics
        trackEvent("Share", action: "Favorites")
    }
}
