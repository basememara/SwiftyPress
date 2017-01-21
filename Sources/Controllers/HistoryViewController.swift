//
//  HistoryViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/6/16.
//
//

import UIKit
import ZamzamKit

class HistoryViewController: UITableViewController, Trackable {
    
    static var segueIdentifier = "HistorySegue"
    
    var models: [String] {
        return AppGlobal.userDefaults[.searchHistory]
    }
    
    var prepareForUnwind: ((String) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.separatorColor = .darkGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        trackPage("History")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        let model = models[indexPath.row]
        
        cell.textLabel?.text = model
        cell.imageView?.image = cell.imageView?.image?.withRenderingMode(.alwaysTemplate)
        
        cell.textLabel?.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissViewController(models[indexPath.row])
    }
    
    func dismissViewController(_ selected: String) {
        prepareForUnwind?(selected)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
