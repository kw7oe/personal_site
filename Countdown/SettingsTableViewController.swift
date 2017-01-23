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
        static let ReminderContent = "Reminder Content"
        static let ReminderTime = "Reminder Time"
        static let SetStartDate = "Set Start Date"
        static let SetGoal = "Set Goal"
    }
    
    // MARK: View
    @IBOutlet weak var reminderOnSwitch: UISwitch! {
        didSet {
            reminderOnSwitch.isOn = Settings.isReminderOn
        }
    }
    
    // Refactoring needed?
    @IBAction func toggleReminderSwitch(_ sender: UISwitch) {        
        let notificationService = NotificationServices()
        if sender.isOn {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if (settings.authorizationStatus == .authorized) {
                    Settings.isReminderOn = sender.isOn
                } else {
                    let alertController = UIAlertController(title: "To enable reminder, you need to turn on notification.", message: nil, preferredStyle: .alert)
                    alertController.addAction(
                        UIAlertAction(
                            title: "Enable Notification",
                            style: .default,
                            handler: { (action) in
                                let url = URL(string: UIApplicationOpenSettingsURLString)
                                UIApplication.shared.open(url!, options: [:]) { _ in
                                    Settings.isReminderOn = sender.isOn
                                }
                            }
                        )
                    )
                    self.present(alertController, animated: true, completion: nil)

                }
                self.tableView.reloadData()
            }

        } else {
            notificationService.removeNotification(withIdentifiers: ["countdownNotification"])
        }
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAt: indexPath)
        if cell.reuseIdentifier == Storyboard.ReminderContent {
            cell.enable(on: Settings.isReminderOn)
            customizeCell(cell: &cell, title: "Set Reminder Content", text: Settings.reminderContent)
        }
        else if cell.reuseIdentifier == Storyboard.ReminderTime {
            cell.enable(on: Settings.isReminderOn)
            customizeCell(cell: &cell, title: "Set Reminder Time", text: Parser.parse(time: Settings.reminderTime))
        }
        else if cell.reuseIdentifier == Storyboard.SetStartDate {
            customizeCell(cell: &cell, title: "Set Start Date", text: Parser.parse(date: Settings.date))
        }
        else if cell.reuseIdentifier == Storyboard.SetGoal {
            customizeCell(cell: &cell, title: "Set Goal", text: String(Settings.goal) + " Days")
        }
        return cell
    }
    
    // MARK: Helper Function
    private func customizeCell( cell: inout UITableViewCell, title: String, text: String) {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = text
        cell.detailTextLabel?.textColor = UIColor.gray
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
    
}
