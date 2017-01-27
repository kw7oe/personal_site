//
//  ReminderTimeTableViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ReminderTimeViewController: UIViewController{

    @IBOutlet weak var datePicker: UIDatePicker!
    var time: Date!
    
    @IBAction func timeDidSelected(_ sender: UIDatePicker) {
        let selectedTime = sender.date
        Settings.reminderTime = selectedTime
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = time
        Settings.reminderTime = time
    }
}



