//
//  SetGoalViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 17/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class SetGoalViewController: UIViewController, UIPickerViewDelegate {
    
    var data: [Int] = Array(1...31)
    var day: Int = 7

    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.selectRow(Settings.goal - 1, inComponent: 0, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        day = data[row]
    }
    
    @IBAction func setGoal(_ sender: UIButton) {
        Settings.goal = day
        
        let notificationService = NotificationServices()
        notificationService.delegate = self
        notificationService.scheduleNotification()
        let alertController = UIAlertController(title: "Your goal has been set to \(day) days.", message: nil, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        
        present(alertController, animated: true, completion: nil)
    }
      
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 37))
        label.text = String(data[row]) + String.pluralize(data[row], input: "day")
        label.textAlignment = .center
        return label
    }

}

extension SetGoalViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
}

extension SetGoalViewController: NotificationServicesDelegate {
    func nameOfIdentifiers() -> String { return "goalNotification" }
    func contentOfNotification() -> String { return "Congratulations" }
    func willRepeat() -> Bool { return false }
    func dateFormat() -> DateComponentFormat { return DateComponentFormat.full }
    func date() -> Date { return Settings.goalDate }
}

