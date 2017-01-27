//
//  ReminderContentTableViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ReminderContentTableViewController: UITableViewController {
    
    var content: String!
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.text = content
            Settings.reminderContent = content
        }
    }
}

// MARK: UITextField Delegate
extension ReminderContentTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        Settings.reminderContent = textField.text!
        
        return true
    }
    
}

extension UITableViewController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor.white
    }
}
