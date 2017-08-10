//
//  AddChallengeTableViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 06/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import CoreData

enum ViewMode {
    case add, edit
}

class AddChallengeTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var challenge: CDChallenge?
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
            nameTextField.textColor = CustomTheme.textColor()
            // Refactor needed
            nameTextField.attributedPlaceholder =
                NSAttributedString(string: "Challenge Name", attributes: [NSForegroundColorAttributeName : CustomTheme.placeholderColor()])
            nameTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var startDatePicker: UIDatePicker! {
        didSet {
            startDatePicker.maximumDate = Date.init()
        }
    }
    @IBOutlet weak var textCountLabel: UILabel! {
        didSet {
            textCountLabel.textColor = CustomTheme.textColor()
        }
    }
    @IBOutlet weak var goalPicker: UIPickerView! {
        didSet {
            goalPicker.dataSource = self
            goalPicker.delegate = self
            var goalIndex: Int = 6
            if mode == .edit {
                goalIndex = Int(challenge!.goal) - 1
            }
            goalPicker.selectRow(goalIndex, inComponent: 0, animated: true)
        }
    }
    
    // MARK: Target Action
    @IBAction func saveChallenge(_ sender: UIBarButtonItem) {
        var name = ""
        if (nameTextField.text != nil && nameTextField.text! != "") {
            name = nameTextField.text!.trimmingCharacters(in: .whitespaces)
            
            let attr = (name, goalPicker.selectedRow(inComponent: 0) + 1, startDatePicker.date, true)
            
            var shouldDismiss = true
            switch mode {
            case .add:
                shouldDismiss = CDChallenge.createChallenge(attr, inContext: context!)
            case .edit:
                _ = CDChallenge.updateChallenge(inContext: context!, unique: challenge!.unique!, with: attr)
            }
            
            if shouldDismiss {
                dismiss()
            } else {
                let alertController = UIAlertController(title: "Duplicated name", message: "Challenge name should be unique", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: {
                    self.nameTextField.text = ""
                })
            }

        } else {
            let alertController = UIAlertController(title: "Name is blank", message: "Challenge name is required", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }

    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateCountFor()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
    private func dismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func updateCountFor() {
        let count = nameTextField.text?.characters.count ?? 0
        textCountLabel.text = "\(count)/20"
    }
    

    
    // MARK: View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mode == .edit {
            startDatePicker.date = (challenge!.date as Date?)!
            nameTextField.text = challenge!.unique
        }
        startDatePicker.changeToWhiteFont()
        updateCountFor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = CustomTheme.backgroundColor()
        self.navigationController?.navigationBar.none()
    }
}

extension AddChallengeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.customize()
        return cell
    }
}

extension AddChallengeTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        let newLength = currentCharacterCount + string.characters.count - range.length
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
