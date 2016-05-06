//
//  PostTableViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/3/16.
//
//

import UIKit
import ZamzamKit

public class SPPostTableViewController: UITableViewController, DataControllable {

    public let cellNibName = "PostTableViewCell"
    public let service = PostService()
    public var models: [Postable] = []
    public var activityIndicator: UIActivityIndicatorView?
    
    public var dataView: DataViewable {
        return tableView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        didLoad()
    }
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath] as! PostTableViewCell
        let model = models[indexPath.row]
        return cell.bind(model)
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(PostDetailViewController.detailSegueIdentifier, sender: nil)
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let row = self.tableView.indexPathForSelectedRow?.row else { return }
        
        if let controller = segue.destinationViewController as? PostDetailViewController {
            // Store model on detail page if applicable
            controller.model = models[row]
        }
    }

}