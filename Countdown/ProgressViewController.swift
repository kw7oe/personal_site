//
//  ProgressViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 18/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

// REFACTOR IS NEEDED!!! CODE SMELL!!!

class ProgressViewController: UIViewController {
    
    @IBOutlet weak var setNewGoalButton: RadiusButton!
    var progressTime: Int {
        return -Int(Settings.date.timeIntervalSinceNow)
    }
    
    
    // Refactor needed.
    func createView() {
        setNewGoalButton.isHidden = true
        // Parse Result
        let parseResult = Parser.parseToArray(time: progressTime, basedOn: Parser.Format.Day)[0]
        let progressDay = Int(parseResult.time)!
        let format = parseResult.unit
        
        // Inner Layer
        // Width and Height for Progress Bar
        let width = view.bounds.width / 2
        let height: CGFloat = 20.0
        
        // Frame
        let frame = CGRect(x: view.bounds.midX - width / 2, y: view.bounds.midY - height / 2, width: width, height: height)
        let rectangleView = UIView(frame: frame)
        rectangleView.backgroundColor = UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 0.5)
        rectangleView.layer.cornerRadius = 10
        
        // Outer Layer
        var progressWidth = (CGFloat(progressDay) / CGFloat(Settings.goal)) * width
        if progressWidth > width { progressWidth = width }
        let progressframe = CGRect(x: view.bounds.midX - width / 2, y: view.bounds.midY - height / 2, width: 0, height: height)
        let progressView = UIView(frame: progressframe)
        progressView.backgroundColor = UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 1)
        progressView.layer.cornerRadius = 10
        
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
        label.center.y = rectangleView.center.y - rectangleView.bounds.height - 20
        view.addSubview(label)
        view.addSubview(rectangleView)
        view.addSubview(progressView)
        UIView.animate(withDuration: 0.9) {
            progressView.frame = CGRect(x: self.view.bounds.midX - width / 2, y: self.view.bounds.midY - height / 2, width: progressWidth, height: height)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
