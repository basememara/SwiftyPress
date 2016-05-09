//
//  Explorer.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/5/16.
//
//

import Foundation

class ExploreViewController: RealmPostCollectionViewController, Tutorable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = AppGlobal.userDefaults[.appName].uppercaseString
        
        // Add toolbar buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "list",
            target: self,
            action: #selector(catagoryTapped),
            bundleIdentifier: AppConstants.bundleIdentifier)
        
        showTutorial(false)
    }
    
    func catagoryTapped() {
        performSegueWithIdentifier(CategoriesViewController.segueIdentifier, sender: nil)
    }
}