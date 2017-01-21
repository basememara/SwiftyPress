//
//  SettingsViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/30/16.
//
//

import UIKit
import MessageUI

class MoreViewController: UITableViewController, MFMailComposeViewControllerDelegate, Tutorable, StatusBarrable, Trackable {
    
    var mainModels = MenuService.storedMoreItems
    var otherModels = MenuService.storedOtherItems
    var socialModels = SocialService.storedItems
    
    var statusBar: UIView?
    
    @IBOutlet weak var socialStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppGlobal.userDefaults[.darkMode] {
            tableView.backgroundColor = .black
            tableView.separatorColor = .darkGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update status bar background since transparent on scroll
        toggleStatusBar(true, target: tabBarController)
        
        trackPage("More")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Status bar no longer needed
        removeStatusBar()
    }
    
    func socialTapped(_ sender: UIButton) {
        guard let social = socialModels.first(where: {
            $0.title == sender.restorationIdentifier
        }) else { return }
        
        // Open social app or url
        if let app = social.app, UIApplication.shared.canOpenURL(URL(string: app)!) {
                UIApplication.shared.open(URL(string: app)!)
        } else if let link = social.link {
            UIApplication.shared.open(URL(string: link)!)
        }
        
        // Google Analytics
        trackEvent("Social", action: sender.restorationIdentifier ?? "")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return AppGlobal.userDefaults[.darkMode] ? .lightContent : .default
    }
}

extension MoreViewController {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return AppGlobal.userDefaults[.appName]
            case 1: return "SOCIAL".localized
            case 2: return "OTHER".localized
            default: return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return mainModels.count
            case 1: return 1
            case 2: return otherModels.count
            default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        var title: String? = nil
        var icon: String? = nil
        
        switch indexPath.section {
            case 0:
                let model = mainModels[indexPath.row]
                title = model.title
                icon = model.icon
            case 1:
                // Clear stackview
                socialStackView.arrangedSubviews.forEach {
                    socialStackView.removeArrangedSubview($0)
                    $0.removeFromSuperview()
                }
                
                // Add button for each social link
                socialModels.forEach { item in
                    if let icon = item.icon,
                        let image = UIImage(named: icon, inBundle: AppConstants.bundle) {
                            let button = UIButton(type: .custom)
                            button.setBackgroundImage(image, for: .normal)
                            button.restorationIdentifier = item.title
                            button.addTarget(self, action: #selector(socialTapped(_:)), for: .touchUpInside)
                            button.widthAnchor.constraint(equalToConstant: 32).isActive = true
                            button.heightAnchor.constraint(equalToConstant: 32).isActive = true
                            socialStackView.addArrangedSubview(button)
                    }
                }
                
                // Position icons in cell
                socialStackView.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(socialStackView)
                socialStackView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 12).isActive = true
                socialStackView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            case 2:
                let model = otherModels[indexPath.row]
                title = model.title
                icon = model.icon
            default: break
        }
        
        // Populate cell contents if applicable
        if let title = title {
            cell.textLabel?.text = title
            
            if let icon = icon {
                cell.imageView?.image = UIImage(named: icon, inBundle: AppConstants.bundle)?
                    .withRenderingMode(.alwaysTemplate)
            }
        }
        
        // Set cell style
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var link: String? = nil
        
        switch indexPath.section {
            case 0:
                let model = mainModels[indexPath.row]
                link = model.link
                
                // Google Analytics
                trackPage(model.title ?? "")
            case 2:
                let model = otherModels[indexPath.row]
                link = model.link
                
                // Google Analytics
                trackPage(model.title ?? "")
            default: break
        }
        
        if let link = link {
            switch link {
                case "{{tutorial}}":
                    showTutorial()
                    
                    // Google Analytics
                    trackEvent("Tutorial", action: "Manual")
                case "{{feedback}}":
                    let mailComposeViewController = configuredMailComposeViewController()
                    if MFMailComposeViewController.canSendMail() {
                        present(mailComposeViewController, animated: true, completion: nil)
                        
                        // Google Analytics
                        trackEvent("Feedback", action: "Email")
                    } else {
                        showSendMailErrorAlert()
                    }
                case "{{rate}}":
                    UIApplication.shared.open(
                        URL(string: "https://itunes.apple.com/app/id\(AppGlobal.userDefaults[.itunesID])")!)
                        
                    // Google Analytics
                    trackEvent("Rate", action: "App")
                case "{{share}}":
                    let message = "\(AppGlobal.userDefaults[.appName]) is awesome! Check out the app!"
                    let share = [message, "https://itunes.apple.com/app/id\(AppGlobal.userDefaults[.itunesID])"]
                    presentActivityViewController(share, sourceView: tableView[indexPath])
                    
                    // Google Analytics
                    trackEvent("Share", action: "App")
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
        presentAlert("Could Not Send Email",
            message: "Your device could not send e-mail. Please check e-mail configuration and try again.")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
