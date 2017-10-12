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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didTermsSelect()
        showTutorial(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willRestorableAppear()
        trackPage("Home - Posts")
    }
    
    override func didTermsSelect() {
        updateTitle()
        updateTerms()
    }
    
    func updateTitle() {
        let title: String = {
            guard let id = termIDs.first, let name = termService.name(for: id), !name.isEmpty
                else { return AppGlobal.userDefaults[.appName] }
            return termIDs.count > 1 ? name + "..." : name
        }()
        
        navigationItem.title = title.uppercased()
        
        // Handle header logo if applicable
        if !AppGlobal.userDefaults[.headerImage].isEmpty, termIDs.isEmpty {
            navigationItem.titleView = UIImageView(image:
                UIImage(named: AppGlobal.userDefaults[.headerImage]))
        } else {
            navigationItem.titleView = nil
        }
    }
    
    func updateTerms() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            imageName: termIDs.isEmpty ? "filter" : "clear-filter",
            target: self,
            action: #selector(catagoryTapped),
            bundleIdentifier: AppConstants.bundleIdentifier
        )
        
        navigationItem.rightBarButtonItem?.tintColor = !termIDs.isEmpty
            ? UIColor(rgb: AppGlobal.userDefaults[.secondaryTintColor])
            : UIColor(rgb: AppGlobal.userDefaults[.tintColor])
    }
    
    @objc func catagoryTapped() {
        performSegue(withIdentifier: TermsViewController.segueIdentifier, sender: nil)
    }
}
