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
    struct Storyboard {
        static let ReminderCell = "Reminder Cell"
        static let AddReminderSegue = "Add Reminder Segue"
        static let EditReminderSegue = "Edit Reminder Segue"
    }
    
    // MARK: View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = Color.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        tableView.reloadData()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let destinationController = navController.visibleViewController as? ReminderConfigurationTableViewController
        {
            if let identifier = segue.identifier {
                switch identifier {
                    case Storyboard.AddReminderSegue:
                        destinationController.alertTitle = "Reminder Added"
                    case Storyboard.EditReminderSegue:
                        destinationController.alertTitle = "Reminder Updated"
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.AddReminderSegue {
            if let count = Settings.reminders?.count, count >= 3 {
                let alertController = UIAlertController(title: "Note", message: "Only a maximum of 3 reminders are allow.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                present(alertController, animated: true, completion: nil)
                return false
            }
        }        
        return true
    }
}


// MARK: TableView data source and delegate
extension RemindersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        if data == nil || data?.count == 0 {
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if data == nil || data?.count == 0 { return nil }
            return "Reminders"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ReminderCell, for: indexPath)
        
        cell.textLabel?.text = data?[indexPath.row].identifier
        cell.addGrayDetail(text: Parser.parse(time: data?[indexPath.row].time))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let identifier = data![indexPath.row].identifier
            Settings.reminders?.remove(at: indexPath.row)
            NotificationServices().removeNotification(withIdentifiers: [identifier])
            tableView.deleteRows(at: [indexPath], with: .fade)
            let rowLeft = tableView.numberOfRows(inSection: 0)
            if rowLeft == 0 {
                 tableView.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.automatic)
            }
           
        }
    }

}
