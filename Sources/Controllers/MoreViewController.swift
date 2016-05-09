//
//  SettingsViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/30/16.
//
//

import UIKit
import MessageUI

class MoreViewController: UITableViewController, MFMailComposeViewControllerDelegate, Tutorable {
    
    var mainModels = MenuService.storedMoreItems
    var socialModels = SocialService.storedItems
    var designedBy = (title: AppGlobal.userDefaults[.designedBy], link: AppGlobal.userDefaults[.designedByURL])
    
    var statusBar: UIView?
    
    @IBOutlet weak var socialStackView: UIStackView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupInterface()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Status bar no longer needed
        statusBar?.removeFromSuperview()
    }
    
    func setupInterface() {
        // Update status bar background since transparent on scroll
        statusBar = tabBarController?.addStatusBar(AppGlobal.userDefaults[.darkMode]
            ? UIColor(white: 0, alpha: 0.8)
            : UIColor(rgb: (239, 239, 244), alpha: 0.8))
    }
    
    func socialTapped(sender: UIButton) {
        guard let social = socialModels.first({
            $0.title == sender.restorationIdentifier
        }) else { return }
        
        // Open social app or url
        if let app = social.app
            where UIApplication.sharedApplication().canOpenURL(NSURL(string: app)!) {
                UIApplication.sharedApplication().openURL(NSURL(string: app)!)
        } else if let link = social.link {
            UIApplication.sharedApplication().openURL(NSURL(string: link)!)
        }
    }
}

extension MoreViewController {

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return AppGlobal.userDefaults[.appName]
            case 1: return "SOCIAL".localized
            case 2: return "OTHER".localized
            default: return ""
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return mainModels.count
            case 1: return 1
            case 2: return 1
            default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        var title: String? = nil
        var icon: String? = nil
        
        switch indexPath.section {
            case 0:
                let model = mainModels[indexPath.row]
                title = model.title
                icon = model.icon
            case 1:
                // Add button for each social link
                socialModels.forEach { item in
                    if let icon = item.icon,
                        let image = UIImage(named: icon, inBundle: AppConstants.bundle) {
                            let button = UIButton(type: .Custom)
                            button.setBackgroundImage(image, forState: .Normal)
                            button.restorationIdentifier = item.title
                            button.addTarget(self, action: #selector(socialTapped(_:)), forControlEvents: .TouchUpInside)
                            button.widthAnchor.constraintEqualToConstant(32).active = true
                            button.heightAnchor.constraintEqualToConstant(32).active = true
                            socialStackView.addArrangedSubview(button)
                    }
                }
                
                // Position icons in cell
                socialStackView.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(socialStackView)
                socialStackView.leftAnchor.constraintEqualToAnchor(cell.leftAnchor, constant: 12).active = true
                socialStackView.centerYAnchor.constraintEqualToAnchor(cell.centerYAnchor).active = true
            case 2:
                title = "Designed by \(designedBy.title)"
                icon = "design"
            default: break
        }
        
        // Populate cell contents if applicable
        if let title = title {
            cell.textLabel?.text = title
            
            if let icon = icon {
                cell.imageView?.image = UIImage(named: icon, inBundle: AppConstants.bundle)?
                    .imageWithRenderingMode(.AlwaysTemplate)
            }
        }
        
        // Set cell style
        cell.selectionStyle = .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var link: String? = nil
        
        switch indexPath.section {
            case 0:
                let model = mainModels[indexPath.row]
                link = model.link
            case 2:
                link = designedBy.link
            default: break
        }
        
        if let link = link {
            switch link {
                case "{{tutorial}}":
                    showTutorial()
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
}

extension MoreViewController {

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
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}