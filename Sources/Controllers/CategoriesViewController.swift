//
//  SPCategoriesViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/5/16.
//
//

import UIKit

public class CategoriesViewController: UITableViewController {
    
    public var models: [(id: Int, title: String, icon: String?)] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve data from defaults
        models = AppGlobal.userDefaults[.categories].flatMap {
            guard let id = $0["id"] as? Int,
                let title = $0["title"] as? String
                    else { return nil }
            
            return (id, title, $0["icon"] as? String)
        }
    }
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        let model = models[indexPath.row]
        
        cell.textLabel?.text = model.title
        
        if let icon = model.icon {
            cell.imageView?.tintColor = UIColor(rgb: AppGlobal.userDefaults[.tintColor])
            cell.imageView?.image = UIImage(named: icon, inBundle: AppConstants.bundle)?
                .imageWithRenderingMode(.AlwaysTemplate)
        }
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = models[indexPath.row]
        dismissViewControllerAnimated(true, completion: nil)
    }
}