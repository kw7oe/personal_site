//
//  AddChallengeTableViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 06/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class AddChallengeTableViewController: UITableViewController {
    
    var challenge: Challenge?
    var goalRange: [Int] = Array(1...31)
    
    // MARK: View Outlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var goalPicker: UIPickerView! {
        didSet {
            goalPicker.dataSource = self
            goalPicker.delegate = self
            var goalIndex: Int = 6
            if challenge != nil {
                goalIndex = challenge!.goal - 1
            }
            goalPicker.selectRow(goalIndex, inComponent: 0, animated: true)
        }
    }
    
    // MARK: Target Action
    @IBAction func saveChallenge(_ sender: UIBarButtonItem) {
        let challenge = Challenge.init(
            name: nameTextField.text ?? "Challenge",
            date: startDatePicker.date,
            goal: goalPicker.selectedRow(inComponent: 0) + 1,
            started: true)
        Settings.prependChallenge(with: challenge)
        dismiss()
    }
   
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
    private func dismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}


extension AddChallengeTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return goalRange.count
    }
}

extension AddChallengeTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 37))
        label.text = String(goalRange[row]) + String.pluralize(goalRange[row], input: "day")
        label.textAlignment = .center
        
        // Dark Theme
        label.updateFontColor()
        return label
    }

}
