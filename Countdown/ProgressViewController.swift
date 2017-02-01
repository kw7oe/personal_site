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
        
        
//        let width = view.bounds.width / 2
//        let height: CGFloat = 20.0
//        let frame = CGRect(x: view.bounds.midX - width / 2, y: view.bounds.midY - height / 2, width: width, height: height)
//        let progressBarView = ProgressBarView(frame: frame, with: percentage)
//        view.addSubview(progressBarView)
        //        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
        //            progressBarView.setProgressBarWidth()
        //        }, completion: nil)
        
        let percentage = (CGFloat(progressDay) / CGFloat(Settings.goal))


        let pieFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let pieView = ProgressPieView(frame: pieFrame)
        // Label
        let labelFrame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 8)
        let label = UILabel(frame: labelFrame)
        let percentageText = String.init(format: "%.1f", percentage * 100)
        var textOutput = "\(percentageText)%\n" + String(Settings.goal - progressDay) + format + "left"
        if (Settings.goal - progressDay <= 0) {
            textOutput = "Completed"
            setNewGoalButton.isHidden = false
        }
        label.text = textOutput
        label.numberOfLines = 2
        label.textAlignment = .center
        label.center = view.center
        view.addSubview(label)
        view.addSubview(pieView)
        
        pieView.setProgress(with: percentage)
    }

 
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: View Life Cycle    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let navigationBar =  self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar?.barTintColor = UIColor.white
        navigationBar?.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
}


