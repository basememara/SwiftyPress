//
//  RealmPostTableViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/8/16.
//
//

import UIKit
import ZamzamKit
import RealmSwift
import RateLimit

class RealmPostTableViewController: UITableViewController, PostControllable {

    var notificationToken: NotificationToken?
    var models: Results<Post>?
    let service = PostService()
    let cellNibName: String? = "PostTableViewCell"
    
    var indexPathForSelectedItem: IndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    var termIDs: [Int] = [] {
        didSet {
            applyTerms(for: termIDs)
            didTermsSelect()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didDataControllableLoad()
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.separatorColor = .darkGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve latest posts not more than every X hours
        _ = AppGlobal.postRefreshLimit.execute {
            service.updateFromRemote()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepare(for: segue)
    }
    
    func didTermsSelect() {
    
    }
}

extension RealmPostTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath] as! PostTableViewCell
        guard let model = models?[indexPath.row] else { return cell }
        return cell.bind(model)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: PostDetailViewController.segueIdentifier, sender: nil)
    }
}
