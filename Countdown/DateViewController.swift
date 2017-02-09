//
//  DateViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    // MARK: View Outlet
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {           
            datePicker.locale = Locale.current
        }
    }
    
    // MARK: Target Action
    @IBAction func dateDidSelected(_ sender: UIDatePicker) {
        Settings.date = sender.date
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = Settings.date
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = Color.backgroundColor        
        datePicker.maximumDate = Date.init()
        
        // Dark Theme
        datePicker.changeToWhiteFont()
    }
}

extension UIDatePicker {
    
    // Dark Theme
    func changeToWhiteFont() {
        self.setValue(UIColor.white, forKey: "textColor")
        self.setValue(false, forKey: "highlightsToday")
    }
}
