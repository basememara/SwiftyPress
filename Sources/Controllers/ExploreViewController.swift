//
//  Explorer.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/5/16.
//
//

import Foundation

class ExploreViewController: RealmPostCollectionViewController, Tutorable, Restorable, Trackable {
    
    var restorationHandlers: [() -> Void] = []
    
    lazy var categoryButton: UIBarButtonItem = {
        return UIBarButtonItem(imageName: "list",
            target: self,
            action: #selector(catagoryTapped),
            bundleIdentifier: AppConstants.bundleIdentifier)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = AppGlobal.userDefaults[.appName].uppercaseString
        navigationItem.rightBarButtonItem = categoryButton
        
        showTutorial(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        willRestorableAppear()
        willTrackableAppear("Home - Posts")
    }
    
    override func didCategorySelect() {
        navigationItem.title = (categoryID > 0
            ? CategoryService.storedItems
                .first { $0.id == categoryID }?.title
                    ?? AppGlobal.userDefaults[.appName]
            : AppGlobal.userDefaults[.appName]).uppercaseString
        
        categoryButton.tintColor = categoryID > 0
            ? UIColor(rgb: AppGlobal.userDefaults[.secondaryTintColor])
            : UIColor(rgb: AppGlobal.userDefaults[.tintColor])
    }
    
    func catagoryTapped() {
        performSegueWithIdentifier(CategoriesViewController.segueIdentifier, sender: nil)
    }
}