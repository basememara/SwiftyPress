//
//  PostControllable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import Foundation

protocol PostControllable: RealmControllable {
    var termIDs: [Int] { get set }
    func didTermsSelect() -> Void
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
            case (TermsViewController.segueIdentifier, let navController as UINavigationController):
                guard let controller = navController.topViewController as? TermsViewController else { break }
                    
                // Set category and prepare to retrieve category
                controller.selectedIDs = termIDs
                controller.prepareForUnwind = {
                    self.termIDs = $0
                }
            default: break
        }
    }
    
    func applyTerms(for ids: [Int]) {
        guard !ids.isEmpty else { return applyFilterAndSort(nil) }
        let filter = "ANY categories.id IN %@ || ANY tags.id IN %@"
        
        applyFilterAndSort(predicate: NSPredicate(format: filter, ids, ids))
    }
}
