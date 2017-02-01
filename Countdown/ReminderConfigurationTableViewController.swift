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
    
    // MARK: Model
    var reminder: Reminder?
    var reminderIndex: Int?
    var alertTitle = ""
   
    @IBOutlet weak var reminderContentTextField: UITextField! {
        didSet {
            reminderContentTextField.delegate = self
            reminderContentTextField.text = reminder?.content
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!
            
    // MARK: Target Action
    @IBAction func saveReminder(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        
        if let reminder = self.reminder {
            reminder.content = reminderContentTextField.text!
            reminder.time = datePicker.date
            Settings.updateReminderAt(index: reminderIndex!, with: reminder)
        } else {
            let reminder = Reminder(identifier: "Reminder 1", content: reminderContentTextField.text!, time: datePicker.date, willRepeat: true)
            
            
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
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismissModal()
        })
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismissModal()
    }
    
    private func dismissModal() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = reminder?.time ?? Date.init()
    }

}

// MARK: UIViewControllerTransitioning Delegate
extension ReminderConfigurationTableViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
}

// MARK: UITextField Delegate
extension ReminderConfigurationTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reminder?.content = textField.text!
        return true
    }
}




