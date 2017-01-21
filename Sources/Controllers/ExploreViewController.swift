//
//  Explorer.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/5/16.
//
//

import Foundation
import ZamzamKit

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
        
        navigationItem.rightBarButtonItem = categoryButton
        
        updateTitle()
        showTutorial(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willRestorableAppear()
        trackPage("Home - Posts")
    }
    
    override func didCategorySelect() {
        categoryButton.tintColor = categoryID > 0
            ? UIColor(rgb: AppGlobal.userDefaults[.secondaryTintColor])
            : UIColor(rgb: AppGlobal.userDefaults[.tintColor])
        
        updateTitle()
    }
    
    func updateTitle() {
        navigationItem.title = (categoryID > 0
            ? CategoryService.storedItems
                .first { $0.id == categoryID }?.title
                    ?? AppGlobal.userDefaults[.appName]
            : AppGlobal.userDefaults[.appName]).uppercased()
        
        // Handle header logo if applicable
        if !AppGlobal.userDefaults[.headerImage].isEmpty && categoryID == 0 {
            navigationItem.titleView = UIImageView(image: UIImage(named:
                AppGlobal.userDefaults[.headerImage]))
        } else {
            navigationItem.titleView = nil
        }
    }
    
    func catagoryTapped() {
        performSegue(withIdentifier: CategoriesViewController.segueIdentifier, sender: nil)
    }
}
