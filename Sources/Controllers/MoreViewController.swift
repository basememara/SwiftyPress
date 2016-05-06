//
//  SettingsViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/30/16.
//
//

import UIKit
import MessageUI

public class MoreViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    public var mainModels: [(title: String?, link: String?, icon: String?)] = []
    public var socialModels: [(title: String?, link: String?, icon: String?, app: String?)] = []
    public var otherModels: (title: String?, link: String?)?
    
    var statusBar: UIView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupInterface()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Status bar no longer needed
        statusBar?.removeFromSuperview()
    }
    
    public func setupInterface() {
        // Update status bar background since transparent on scroll
        statusBar = tabBarController?.addStatusBar(AppGlobal.userDefaults[.darkMode]
            ? UIColor(white: 0, alpha: 0.8)
            : UIColor(rgb: (239, 239, 244), alpha: 0.8))
    }
    
    public func loadData() {
        // Retrieve data from defaults
        mainModels = AppGlobal.userDefaults[.moreMenu].map {
            ($0["title"] as? String, $0["link"] as? String, $0["icon"] as? String)
        }
        
        socialModels = AppGlobal.userDefaults[.social].map {
            ($0["title"] as? String, $0["link"] as? String, $0["icon"] as? String, $0["app"] as? String)
        }
        
        otherModels = (AppGlobal.userDefaults[.designedBy], AppGlobal.userDefaults[.designedByURL])
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return AppGlobal.userDefaults[.appName]
            case 1: return "SOCIAL"
            case 2: return "OTHER"
            default: return ""
        }
    }
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return mainModels.count
            case 1: return 1
            case 2: return 1
            default: return 0
        }
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        var title: String? = nil
        var icon: String? = nil
        
        switch indexPath.section {
            case 0:
                let model = mainModels[indexPath.row]
                title = model.title
                icon = model.icon
            //case 1:
            
            case 2:
                guard let designedBy = otherModels?.title else { break }
                title = "Designed by \(designedBy)"
                icon = "design"
            default: break
        }
        
        // Populate cell contents if applicable
        if let title = title {
            cell.textLabel?.text = title
            
            if let icon = icon {
                cell.imageView?.tintColor = UIColor(rgb: AppGlobal.userDefaults[.tintColor])
                cell.imageView?.image = UIImage(named: icon, inBundle: AppConstants.bundle)?
                    .imageWithRenderingMode(.AlwaysTemplate)
            }
        }
        
        // Set cell style
        cell.selectionStyle = .None
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var link: String? = nil
        
        switch indexPath.section {
            case 0:
                let model = mainModels[indexPath.row]
                link = model.link
            //case 1:
            
            case 2:
                link = otherModels?.link
            default: break
        }
        
        if let link = link {
            switch link {
                case "{{tutorial}}":
                    print(link)
                case "{{feedback}}":
                    let mailComposeViewController = configuredMailComposeViewController()
                    if MFMailComposeViewController.canSendMail() {
                        self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                    } else {
                        self.showSendMailErrorAlert()
                    }
                case "{{rate}}":
                    UIApplication.sharedApplication().openURL(
                        NSURL(string: "http://appstore.com/\(AppGlobal.userDefaults[.itunesName])")!)
                case "{{share}}":
                    let message = "\(AppGlobal.userDefaults[.appName]) is awesome! Check out the app!"
                    let share = [message, link]
                    let activity = UIActivityViewController(activityItems: share, applicationActivities: nil)
                    presentViewController(activity, animated: true, completion: nil)
                default:
                    presentSafariController(link)
            }
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([AppGlobal.userDefaults[.email]])
        mailComposer.setSubject("Feedback: \(AppGlobal.userDefaults[.appName])")
        
        return mailComposer
    }
    
    func showSendMailErrorAlert() {
        alert("Could Not Send Email",
            message: "Your device could not send e-mail. Please check e-mail configuration and try again.")
    }
    
    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}