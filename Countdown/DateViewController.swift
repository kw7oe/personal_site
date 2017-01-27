//
//  DateViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {


    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {           
            datePicker.locale = Locale.current
        }
    }
    
    @IBAction func dateDidSelected(_ sender: UIDatePicker) {
        Settings.date = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = Settings.date
    }
}
