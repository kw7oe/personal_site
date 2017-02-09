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
            reminderContentTextField.textColor = UIColor.white
            reminderContentTextField.attributedPlaceholder =
                NSAttributedString(string: "Write Some Encouraging Words For Yourself", attributes: [NSForegroundColorAttributeName : UIColor.init(white: 0.60, alpha: 1)])
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
            Settings.updateReminderAt(index: reminderIndex!, with: reminder)
        }
        else // Reminder in Add Mode
        {
            let reminder = Reminder(identifier: Settings.reminderIdentifier.removeFirst(), content: content!, time: datePicker.date, willRepeat: true)
            
            // Check if Settings.reminders exists
            if Settings.reminders != nil { // If yes, change reminder's identifier
                Settings.appendReminder(reminder: reminder)
            } else { // if no, directly append
                Settings.appendReminder(reminder: reminder)
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
        cell.black()
        return cell
    }
    
    
    // MARK: View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = Color.backgroundColor
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




