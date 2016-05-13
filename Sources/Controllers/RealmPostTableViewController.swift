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
    
    var dataView: DataViewable {
        return tableView
    }
    
    var indexPathForSelectedItem: NSIndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    var categoryID: Int = 0 {
        didSet { 
            applyFilterAndSort(filter: categoryID > 0
                ? "ANY categories.id == \(categoryID)" : nil)
            didCategorySelect()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didDataControllableLoad()
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.separatorColor = .darkGrayColor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve latest posts not more than every X hours
        RateLimit.execute(name: "UpdatePostsFromRemote", limit: 10800) {
            service.updateFromRemote()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        prepareForSegue(segue)
    }
    
    func didCategorySelect() {
    
    }
}

extension RealmPostTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath] as! PostTableViewCell
        guard let model = models?[indexPath.row] else { return cell }
        return cell.bind(model)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(PostDetailViewController.segueIdentifier, sender: nil)
    }
}