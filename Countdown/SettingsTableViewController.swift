//
//  SettingsTableViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsTableViewController: UITableViewController {
    
    // MARK: Storyboard
    private struct Storyboard {
        static let AddReminder = "Add Reminder"
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
    
    // MARK: View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if cell.reuseIdentifier == Storyboard.AddReminder {
            cell.enable(on: Settings.isReminderOn)
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
        return cell
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
}
