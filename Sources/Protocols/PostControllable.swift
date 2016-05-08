//
//  PostControllable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation

protocol PostControllable: RealmControllable {
    associatedtype DataType: Post
    
    var categoryID: Int { get set }
}

extension PostControllable where Self: UIViewController {

    func filterByCategory() {
        // Filter view when set
        if categoryID > 0 {
            models = realm?.objects(DataType.self)
                .filter("ANY categories.id == %@", categoryID)
                .sorted(sortProperty, ascending: sortAscending)
        }
        else {
            models = realm?.objects(DataType.self)
                .sorted(sortProperty, ascending: sortAscending)
        }

        dataView.reloadData()
        dataView.scrollToTop()
    }

    func prepareForSegue(segue: UIStoryboardSegue) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch (segueIdentifier, segue.destinationViewController) {
            case (PostDetailViewController.segueIdentifier, let controller as PostDetailViewController):
                // Set post detail
                guard let row = indexPathForSelectedItem?.row,
                    let model = models?[row] as? Postable else { break }
                controller.model = model
            case (CategoriesViewController.segueIdentifier, let navController as UINavigationController):
                guard let controller = navController.topViewController as? CategoriesViewController else { break }
                    
                // Set category and prepare to retrieve category
                controller.selectedID = categoryID
                controller.prepareForUnwind = { [unowned self] id in
                    self.categoryID = id
                    self.navigationItem.title = (self.categoryID > 0
                        ? CategoryService.storedItems
                            .first { $0.id == self.categoryID }?.title
                                ?? AppGlobal.userDefaults[.appName]
                        : AppGlobal.userDefaults[.appName]).uppercaseString
                }
            default: break
        }
    }
}