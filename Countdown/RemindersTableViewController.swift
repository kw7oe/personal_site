//
//  RemindersTableViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 24/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class RemindersTableViewController: UITableViewController {
    
    var data: [Reminder]? {
        return Settings.reminders
    }
    var label: UILabel?
    
    // MARK: Storyboard
    private struct Storyboard {
        static let ReminderCell = "Reminder Cell"
        static let AddReminderSegue = "Add Reminder Segue"
        static let EditReminderSegue = "Edit Reminder Segue"
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        if data?.count == 0 {
            label?.text = "No Reminder Available"
            label?.textColor = UIColor.black
            label?.textAlignment = .center
            tableView.backgroundView = label
            tableView.separatorStyle = .none            
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine            
        }
        
        return numberOfSection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ReminderCell, for: indexPath)

        cell.textLabel?.text = data?[indexPath.row].identifier

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let identifier = data![indexPath.row].identifier
            Settings.reminders?.remove(at: indexPath.row)
            NotificationServices().removeNotification(withIdentifiers: [identifier])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        tableView.reloadData()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? ReminderConfigurationTableViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case Storyboard.AddReminderSegue:
                    destinationController.set(alertTitle: "Reminder Added", buttonTitle: "Add Reminder")
                case Storyboard.EditReminderSegue:
                    destinationController.set(alertTitle: "Reminder Updated", buttonTitle: "Update Reminder")
                default: break;
                }
            }
            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)!
                destinationController.reminder = data?[indexPath.row]
                destinationController.reminderIndex = indexPath.row
            }
        }
    }
}
