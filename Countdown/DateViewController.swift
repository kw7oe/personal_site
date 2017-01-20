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

    @IBAction func setDate(_ sender: UIButton) {
        Settings.date = datePicker.date
        
        let alertController = UIAlertController(title: "Your start date has been reset.", message: nil, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = Settings.date
    }
}
