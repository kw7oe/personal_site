//
//  ReminderTimeTableViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ReminderTimeViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func setTime(_ sender: Any) {
        let selectedTime = datePicker.date
        
        // Format String
       
        let time = Parser.parse(time: selectedTime)
        Settings.reminderTime = selectedTime

        let notificationService = NotificationServices()
        notificationService.delegate = self
        notificationService.scheduleNotification()
        
        // Setup Alert Controller
        // Code Smell: Code Duplication
        let alertController = UIAlertController(title: "Your reminder has been set to \(time) every day.", message: nil, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (action) in
                    
                    
                }
            )
        )
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = Settings.reminderTime
    }
}

extension ReminderTimeViewController: NotificationServicesDelegate {
    func nameOfIdentifiers() -> String { return "reminderNotifications" }
    func contentOfNotification() -> String { return "An apple a day, keep the doctor away." }
    func willRepeat() -> Bool { return true }
    func dateFormat() -> DateComponentFormat { return DateComponentFormat.short }
    func date() -> Date { return datePicker.date }
}

