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

    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.selectRow(Settings.goal - 1, inComponent: 0, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Settings.goal = data[row]
        
        let alertController = UIAlertController(title: "Your goal has been set to \(data[row]) days.", message: nil, preferredStyle: .alert)
        alertController.transitioningDelegate = self
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
        
        // Dark Theme
        label.updateFontColor()
        return label
    }
    
    
    // MARK: View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = Color.backgroundColor()
    }

}

// MARK: UIViewController Transitioning Delegate Extension
extension SetGoalViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
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


