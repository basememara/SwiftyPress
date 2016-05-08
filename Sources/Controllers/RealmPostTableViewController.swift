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

class RealmPostTableViewController: UITableViewController, PostControllable {

    var realm: Realm?
    var notificationToken: NotificationToken?
    var models: Results<Post>?
    let service = PostService()

    let cellNibName = "PostTableViewCell"
    
    var dataView: DataViewable {
        return tableView
    }
    
    var indexPathForSelectedItem: NSIndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        return self.setupActivityIndicator()
    }()
    
    var categoryID: Int = 0 {
        didSet { filterByCategory() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        prepareForSegue(segue)
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