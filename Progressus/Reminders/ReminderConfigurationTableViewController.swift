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
    let defaultContent = "Nothing can stop the man with the right mental attitude from achieving his goal."
   
    // MARK: View Outlet
    @IBOutlet weak var reminderContentTextField: UITextField! {
        didSet {
            reminderContentTextField.delegate = self
            reminderContentTextField.text = reminder?.content ?? defaultContent
            
            // Dark Theme
            reminderContentTextField.textColor = CustomTheme.textColor()
            reminderContentTextField.attributedPlaceholder =
                NSAttributedString(string: "Write Some Encouraging Words For Yourself", attributes: [NSForegroundColorAttributeName : CustomTheme.placeholderColor()])
        }
    }
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
            
    // MARK: Target Action
    @IBAction func saveReminder(_ sender: UIBarButtonItem) {
        var content = reminderContentTextField.text
        if content == nil || content == "" {
            content = defaultContent
        }
        if let reminder = self.reminder // Reminder In Edit Mode
        {
            reminder.content = content!
            reminder.time = datePicker.date
            ReminderFactory.updateReminderAt(index: reminderIndex!, with: reminder)
        }
        else // Reminder in Add Mode
        {
            let reminder = Reminder(identifier: ReminderFactory.reminderIdentifier.removeFirst(), content: content!, time: datePicker.date, willRepeat: true)
            
            // Check if Settings.reminders exists
            if ReminderFactory.reminders != nil { // If yes, change reminder's identifier
                ReminderFactory.appendReminder(reminder: reminder)
            } else { // if no, directly append
                ReminderFactory.appendReminder(reminder: reminder)
            }
           
        }
        
        // Alert Controller
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
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
    
    // MARK: Private Method
    private func dismissModal() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Dark Theme
        cell.customize()
        return cell
    }
    
    
    // MARK: View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = CustomTheme.backgroundColor()
        self.navigationController?.navigationBar.none()
        saveButton.style = .done
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.date = reminder?.time ?? Date.init()
        datePicker.changeToWhiteFont()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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




