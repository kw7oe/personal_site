//
//  AddChallengeTableViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 06/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

enum ViewMode {
    case add, edit
}

class AddChallengeTableViewController: UITableViewController {
    
    var challenge: Challenge?
    var challengeIndex: Int?
    var mode: ViewMode {
        if challenge != nil {
            return .edit
        }
        return .add
    }
    var goalRange: [Int] = Array(1...31)
    
    
    // MARK: View Outlet
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var goalPicker: UIPickerView! {
        didSet {
            goalPicker.dataSource = self
            goalPicker.delegate = self
            var goalIndex: Int = 6
            if mode == .edit {
                goalIndex = challenge!.goal - 1
            }
            goalPicker.selectRow(goalIndex, inComponent: 0, animated: true)
        }
    }
    
    // MARK: Target Action
    @IBAction func saveChallenge(_ sender: UIBarButtonItem) {
        let challenge = Challenge.init(
            name: nameTextField.text ?? "Challenge",
            date: Date.init(),
            goal: goalPicker.selectedRow(inComponent: 0) + 1,
            started: true)
        
        switch mode {
          case .add: Settings.prependChallenge(with: challenge)
          case .edit:
            challenge.set_date(startDatePicker.date)
            Settings.updateChallenge(at: challengeIndex!, with: challenge)
        }
        
        dismiss()
    }
   
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
    private func dismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateCountFor(editing: Bool) {
        var count = nameTextField.text?.characters.count ?? 0
        if editing {
            count += 1
            if count > 20 { count = 20 }
        }
        textCountLabel.text = "\(count)/20"
    }

    
    // MARK: View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mode == .edit {
            startDatePicker.date = challenge!.date
            nameTextField.text = challenge!.name
        }
        updateCountFor(editing: false)
    }
}

extension AddChallengeTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        updateCountFor(editing: true)
        return newLength < 21
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
