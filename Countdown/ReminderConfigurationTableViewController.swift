//
//  ReminderConfigurationTableViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 23/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

// Change this to modal 
class ReminderConfigurationTableViewController: UITableViewController {
   
    @IBOutlet weak var button: UIButton!
    var buttonTitle = ""
    var alertTitle = ""
    
    func set(alertTitle: String, buttonTitle: String) {
        self.alertTitle = alertTitle
        self.buttonTitle = buttonTitle
    }
    
    // MARK: Model
    var reminder: Reminder?
    var reminderIndex: Int?
    
    // CODE SMELLLL!!!
    @IBAction func addReminder(_ sender: UIButton) {
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)

        if let reminder = self.reminder {
            reminder.content = Settings.reminderContent
            reminder.time = Settings.reminderTime
            Settings.updateReminderAt(index: reminderIndex!, with: reminder)
        } else {
            let reminder = Reminder(identifier: "Reminder 1", content: Settings.reminderContent, time: Settings.reminderTime, willRepeat: true)
            
            
            if let reminders = Settings.reminders {
                reminder.identifier = "Reminder \(reminders.count + 1)"
                let needDisplayAlert = Settings.appendReminder(reminder: reminder)
                if needDisplayAlert {
                    alertController.message = "Note: Only a maximum of 3 reminders are allow. The first reminder will be removed."
                }
            } else {
                _ = Settings.appendReminder(reminder: reminder)
            }
        }
        alertController.transitioningDelegate = self
        alertController.modalPresentationStyle = .custom
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Storyboard
    private struct Storyboard {
        static let ReminderContent = "Reminder Content"
        static let ReminderTime = "Reminder Time"
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

         if cell.reuseIdentifier == Storyboard.ReminderContent {
            cell.addGrayDetail(text: reminder?.content ?? "")
         }
         else if cell.reuseIdentifier == Storyboard.ReminderTime {
            cell.addGrayDetail(text: Parser.parse(time: reminder?.time))
         }
        return cell
    }
    

    // MARK: View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.setTitle(buttonTitle, for: UIControlState.normal)
        button.sizeToFit()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let rctvc = segue.destination as? ReminderContentTableViewController {
            rctvc.content = reminder?.content ?? "Nothing can stop the man with the right mental attitude from achieving his goal."
        } else if let rtvc = segue.destination as? ReminderTimeViewController {
            rtvc.time = reminder?.time ?? Date.init()
        }
    }
}

extension ReminderConfigurationTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
}


