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
    
    var challenge: Challenge!
    var challengeIndex: Int = 0
    
    // MARK: Storyboard
    fileprivate struct Storyboard {
        static let EnableReminder = "Enable Reminder"
        static let EnableDarkTheme = "Enable Dark Theme"
        static let ViewAllReminders = "View All Reminders"
        static let SetStartDate = "Set Start Date"
        static let SetGoal = "Set Goal"
        static let InAppPurchase = "In-App Purchase"
    }
    
    // MARK: View Outlet
    @IBOutlet weak var reminderOnSwitch: UISwitch! {
        didSet {
            reminderOnSwitch.isOn = Settings.isReminderOn
        }
    }
    @IBOutlet weak var darkThemeSwitch: UISwitch! {
        didSet {
            darkThemeSwitch.isOn = Settings.theme == .dark
        }
    }
    @IBOutlet weak var enableReminderLabel: UILabel!
    @IBOutlet weak var darkThemeLabel: UILabel!
    
    // MARK: Target Action
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
    
    @IBAction func toggleDarkTheme(_ sender: UISwitch) {
        if sender.isOn {
            Settings.theme = .dark
        } else {
            Settings.theme = .blue
        }
        
        updateUI()
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
        self.view.backgroundColor = CustomTheme.backgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Private Method 
    private func updateUI() {
        view.setNeedsDisplay()
        view.setNeedsLayout()
        view.window?.tintColor = CustomTheme.primaryColor()
        tableView.reloadData()
        navigationController?.navigationBar.barStyle = CustomTheme.barStyle()
    }
    
    // MARK: Navigation
    private struct Segue {
        static let SetGoal = "Set Goal Segue"
        static let SetDate = "Set Date Segue"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Segue.SetGoal {
            if let dvc = segue.destination as? SetGoalViewController {
                dvc.challenge = challenge
                dvc.challengeIndex = challengeIndex
            }
        }
        else if segue.identifier == Segue.SetDate {
            if let dvc = segue.destination as? DateViewController {
                dvc.challenge = challenge
                dvc.challengeIndex = challengeIndex
            }
        }
    }
}

// MARK: - Table view data source
extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if cell.reuseIdentifier == Storyboard.EnableReminder {
            enableReminderLabel.updateFontColor()
        }
        else if cell.reuseIdentifier == Storyboard.EnableDarkTheme {
            darkThemeLabel.updateFontColor()
        }
        else if cell.reuseIdentifier == Storyboard.ViewAllReminders {
            cell.enable(on: Settings.isReminderOn)
            let count = Settings.reminders?.count ?? 0
            cell.addGrayDetail(text: String(count) + String.pluralize(count, input: "Reminder"))
        }
        else if cell.reuseIdentifier == Storyboard.SetStartDate {
            cell.addGrayDetail(text: Parser.parse(date: challenge.date))
        }
        else if cell.reuseIdentifier == Storyboard.SetGoal {
            cell.addGrayDetail(text: String(challenge.goal) + " Days")
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
