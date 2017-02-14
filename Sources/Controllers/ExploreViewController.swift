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
    
    let termService = TermService()
    var restorationHandlers: [() -> Void] = []
    
    lazy var categoryButton: UIBarButtonItem = {
        return UIBarButtonItem(imageName: "filter",
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
    
    override func didTermsSelect() {
        categoryButton.tintColor = !termIDs.isEmpty
            ? UIColor(rgb: AppGlobal.userDefaults[.secondaryTintColor])
            : UIColor(rgb: AppGlobal.userDefaults[.tintColor])
        
        updateTitle()
    }
    
    func updateTitle() {
        let title: String = {
            guard let id = termIDs.first, let name = termService.name(for: id), !name.isEmpty
                else { return AppGlobal.userDefaults[.appName] }
            return termIDs.count > 1 ? name + "..." : name
        }()
        
        navigationItem.title = title.uppercased()
        
        // Handle header logo if applicable
        if !AppGlobal.userDefaults[.headerImage].isEmpty && termIDs.isEmpty {
            navigationItem.titleView = UIImageView(image:
                UIImage(named: AppGlobal.userDefaults[.headerImage]))
        } else {
            navigationItem.titleView = nil
        }
    }
    
    func catagoryTapped() {
        performSegue(withIdentifier: TermsViewController.segueIdentifier, sender: nil)
    }
}

