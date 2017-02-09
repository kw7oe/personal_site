//
//  SettingsTableViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import UserNotifications
import MessageUI

class SettingsTableViewController: UITableViewController {
    
    // MARK: Storyboard
    private struct Storyboard {
        static let EnableReminder = "Enable Reminder"
        static let ViewAllReminders = "View All Reminders"
        static let SetStartDate = "Set Start Date"
        static let SetGoal = "Set Goal"
    }
    
    // MARK: Target Action
    @IBOutlet weak var reminderOnSwitch: UISwitch! {
        didSet {
            reminderOnSwitch.isOn = Settings.isReminderOn
        }
    }
    
    @IBAction func toggleReminderSwitch(_ sender: UISwitch) {
        let notificationService = NotificationServices()
        
        if let reminders = Settings.reminders {
            if sender.isOn {
                for reminder in reminders {
                    notificationService.scheduleNotification(with: reminder, basedOn: .short)
                }
            } else {
                let identifiers = reminders.map({ (reminder) -> String in
                    return reminder.identifier
                })
                notificationService.removeNotification(withIdentifiers: identifiers)
            }
        }        
        Settings.isReminderOn = sender.isOn
        tableView.reloadData()
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            
            mailVC.setToRecipients(["choongkwern@hotmail.com"])
            mailVC.setSubject("Progressus - Feedback")
            
            present(mailVC, animated: true, completion: nil)

        } else {
            let alertController = UIAlertController(title: "Sorry", message: "Mail services are not available", preferredStyle: .alert)
            alertController.transitioningDelegate = self
            alertController.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                )
            )
            present(alertController, animated: true, completion: nil)
        }
    }
    // MARK: View Life Cycle  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = Color.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if cell.reuseIdentifier == Storyboard.EnableReminder {
            
        }
        else if cell.reuseIdentifier == Storyboard.ViewAllReminders {
            cell.enable(on: Settings.isReminderOn)
            let count = Settings.reminders?.count ?? 0
            cell.addGrayDetail(text: String(count) + String.pluralize(count, input: "Reminder"))
        }
        else if cell.reuseIdentifier == Storyboard.SetStartDate {
            cell.addGrayDetail(text: Parser.parse(date: Settings.date))
        }
        else if cell.reuseIdentifier == Storyboard.SetGoal {
            cell.addGrayDetail(text: String(Settings.goal) + " Days")
        }
        
        // Dark Theme
        cell.black()
        return cell
    }
}

// MARK: MFMailCompose View Controller Delegate Extension
extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.transitioningDelegate = self
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        switch result {
        case .sent:
            alertController.message = "Successfully send email. Thank you for the feedback."
        case .failed:
            alertController.message = "Fail to send email. Please try again later."
        default:
            break;
        }
        controller.dismiss(animated: true) { completed in
            if alertController.message != nil  {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: UIViewController Transitioning Delegate Extension
extension SettingsTableViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
}

// MARK: Table View Cell Extension
extension UITableViewCell {
    func enable(on status: Bool) {
        self.isUserInteractionEnabled = status
        for view in self.contentView.subviews {
            view.alpha = status ? 1 : 0.4
        }
    }
    
    func addGrayDetail(text: String) {
        self.detailTextLabel?.text = text
        self.detailTextLabel?.textColor = UIColor.gray
    }
    
    // Dark Theme
    func black() {
        self.backgroundColor = Color.backgroundColor
        self.textLabel?.textColor = UIColor.init(white: 0.98, alpha: 1)
    }
}
