//
//  PostControllable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation

public protocol PostControllable: DataControllable {
    var selectedCategoryID: Int { get set }
}

extension PostControllable where Self: UIViewController {

    func prepareForSegue(segueIdentifier: String, indexPath: NSIndexPath?, destinationViewController: UIViewController) {
        switch (segueIdentifier, destinationViewController) {
            case (PostDetailViewController.segueIdentifier, let controller as PostDetailViewController):
                // Set post detail
                guard let row = indexPath?.row, let model = models[row] as? Postable else { break }
                controller.model = model
            case (CategoriesViewController.segueIdentifier, let navController as UINavigationController):
                guard let controller = navController.topViewController as? CategoriesViewController
                    else { break }
                    
                // Set category and prepare to retrieve category
                controller.selectedID = selectedCategoryID
                controller.prepareForUnwind = { [unowned self] id in
                    self.selectedCategoryID = id
                    self.loadData()
                    self.navigationItem.title = self.selectedCategoryID > 0
                        ? CategoryService.storedItems
                            .first({ $0.id == self.selectedCategoryID })?.title
                                ?? AppGlobal.userDefaults[.appName]
                        : AppGlobal.userDefaults[.appName]
                }
            default: break
        }
    }
}