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
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: Settings.goalDate, with: "You have achieve your goal.", with: .full)
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
    
 
   

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SetGoalViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
    
}

