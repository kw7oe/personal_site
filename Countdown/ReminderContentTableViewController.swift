//
//  ReminderContentTableViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ReminderContentTableViewController: UITableViewController {

   
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.text = Settings.reminderContent
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
}

// MARK: UITextField Delegate
extension ReminderContentTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        Settings.reminderContent = textField.text!
        
        // Code Smell: Code Duplication
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: Settings.date, with: textField.text!)
        return true
    }
    
}

extension UITableViewController {
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor.white
    }
}
