//
//  ProgressViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 18/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    
    @IBOutlet weak var setNewGoalButton: RadiusButton!
    var progressTime: Int {
        return -Int(Settings.date.timeIntervalSinceNow)
    }
    
    // Create Custom View
    func createView() {
        setNewGoalButton.isHidden = true
        let parseResult = Parser.parseToArray(time: progressTime, basedOn: Parser.Format.Day)[0]
        let progressDay = Int(parseResult.time)!
        let format = parseResult.unit
        
        
        let width = view.bounds.width / 2
        let height: CGFloat = 20.0
        
        // Progress Bar
        let frame = CGRect(x: view.bounds.midX - width / 2, y: view.bounds.midY - height / 2, width: width, height: height)
        let percentage = (CGFloat(progressDay) / CGFloat(Settings.goal))
        let progressBarView = ProgressBarView(frame: frame, with: percentage)
       
       
        // Label
        let labelFrame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 8)
        let label = UILabel(frame: labelFrame)
        var textOutput = String(Settings.goal - progressDay) + format + "left"
        if (Settings.goal - progressDay <= 0) {
            textOutput = "Congratulations. Mission Accomplished"
            setNewGoalButton.isHidden = false
        }
        label.text = textOutput
        label.numberOfLines = 2
        label.textAlignment = .center
        label.center.x = view.center.x
        label.center.y =  progressBarView.center.y - progressBarView.frame.height - 20
        view.addSubview(label)
        view.addSubview(progressBarView)
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: { 
            progressBarView.setProgressBarWidth()
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }


}
