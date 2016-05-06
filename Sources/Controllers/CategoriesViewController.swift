//
//  SPCategoriesViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/5/16.
//
//

import UIKit

public class CategoriesViewController: UITableViewController {
    
    public static var segueIdentifier = "CategorySegue"
    
    public var models = CategoryService.storedItems
    public var selectedID: Int = 0
    var prepareForUnwind: (Int -> Void)? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve data from defaults
        models = AppGlobal.userDefaults[.categories].flatMap {
            guard let id = Int($0["id"] as? String ?? ""),
                let title = $0["title"] as? String
                    else { return nil }
            
            return (id, title, $0["icon"] as? String)
        }
        
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .CurrentContext
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
        
        // Select first or previously selected item
        if model.id == selectedID {
            cell.accessoryType = .Checkmark
        }
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedID = models[indexPath.row].id
        
        // Uncheck all rows
        tableView.visibleCells.forEach { cell in
            cell.accessoryType = .None
        }
        
        // Check selected item
        tableView.cellForRowAtIndexPath(indexPath)?
            .accessoryType = .Checkmark
        
        dismissViewController()
    }
    
    func dismissViewController() {
        prepareForUnwind?(selectedID)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func allTapped(sender: AnyObject) {
        selectedID = 0
        dismissViewController()
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

/*
class CategoriesController: UIViewController {
    
    let zamzamManager = ZamzamManager()
    let helpers = Helpers()
    var selected: Int32 = 0
    var prepareForUnwind: ((id: Int32) -> ())?
    
    @IBOutlet var currentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
        Analytics.trackPage("Categories")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppConfig.CATEGORIES.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "categoryCell")
        let entity = AppConfig.CATEGORIES[indexPath.row]
        
        // Apply properties
        cell.textLabel?.text = zamzamManager.webService.decodeHTML(entity.title)
        
        // Apply dark theme to rows
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()
        cell.imageView?.image = UIImage(named: entity.icon)
        
        // Select first or previously selected item
        if Int32(entity.id) == selected {
            cell.accessoryType = .Checkmark
        }
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Store selected entity for later use
        var entity = AppConfig.CATEGORIES[indexPath.row]
        selected = Int32(entity.id)
        
        // Handle check mark toggling if applicable
        for row in 0..<tableView.numberOfRowsInSection(0) {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .Checkmark : .None
            }
        }
        
        dismissViewController()
    }
    
    func dismissViewController() {
        // Process callback for previous controller
        if let callback = prepareForUnwind {
            callback(id: selected)
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func allTapped(sender: AnyObject) {
        selected = 0
        dismissViewController()
    }
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
}
*/