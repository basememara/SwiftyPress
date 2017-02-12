//
//  PostControllable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation

protocol PostControllable: RealmControllable {
    var categoryID: Int { get set }
    func didCategorySelect() -> Void
}

extension PostControllable where Self: UIViewController {

    func prepare(for segue: UIStoryboardSegue) {
        guard let segueIdentifier = segue.identifier else { return }
        
        switch (segueIdentifier, segue.destination) {
            case (PostDetailViewController.segueIdentifier, let controller as PostDetailViewController):
                // Set post detail
                guard let row = indexPathForSelectedItem?.row,
                    let model = models?[row] else { break }
                controller.model = model as? Post
            case (CategoriesViewController.segueIdentifier, let navController as UINavigationController):
                guard let controller = navController.topViewController as? CategoriesViewController else { break }
                    
                // Set category and prepare to retrieve category
                controller.selectedID = categoryID
                controller.prepareForUnwind = { id in
                    self.categoryID = id
                }
            default: break
        }
    }
}
