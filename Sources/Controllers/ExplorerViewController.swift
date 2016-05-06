//
//  Explorer.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/5/16.
//
//

import Foundation

public class ExploreViewController: SPPostCollectionViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = AppGlobal.userDefaults[.appName]
        
        // Add toolbar buttons
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(imageName: "list", target: self, action: #selector(catagoryTapped), bundleIdentifier: AppConstants.bundleIdentifier)
        ]
    }
    
    func catagoryTapped() {
        performSegueWithIdentifier(CategoriesViewController.segueIdentifier, sender: nil)
    }

}