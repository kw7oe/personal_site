//
//  DateViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    var challenge: Challenge!
    var challengeIndex = 0
    
    // MARK: View Outlet
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {           
            datePicker.locale = Locale.current
        }
    }
    
    // MARK: Target Action
    @IBAction func dateDidSelected(_ sender: UIDatePicker) {
        challenge.update(
            at: challengeIndex,
            with: ["date" : sender.date]
        )
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = challenge.date
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = CustomTheme.backgroundColor()
        datePicker.maximumDate = Date.init()
        
        // Dark Theme
        datePicker.changeToWhiteFont()
    }
}


