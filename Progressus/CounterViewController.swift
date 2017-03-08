//
//  ViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 10/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    
    var challengeIndex = 0 
    var challenge: Challenge {
        return Settings.challenges?[challengeIndex] ?? Challenge(name: "", date: Date.init(), goal: 7, started: false)
    }
    var time: Int {
        if !challenge.started { return 0 }
        return -Int(challenge.date.timeIntervalSinceNow)
    }    
    var timer = Timer()
    
    // MARK : View Outlet
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var button: RadiusButton!
    @IBOutlet weak var timeUnitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: ProgressPieView! 
    
    // MARK: Target Action
    @IBAction func resetTime(_ sender: UIButton) {
        if challenge.started {
            resetTimer()
        } else {
            startTimer()
        }
    }
    
    private func resetTimer() {
        let alertController = UIAlertController(title: "Are you sure you want to reset?", message: nil, preferredStyle: .alert)
        alertController.transitioningDelegate = self
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (action) in
                    self.challenge.update(
                        at: self.challengeIndex,
                        with: [
                            "date": Date.init(),
                            "started": false                        
                        ]
                    )
                    self.button.setTitle("START", for: .normal)
                    self.setProgress()
                    self.updateUI()
                }
            )
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func startTimer() {
        challenge.update(
            at: self.challengeIndex,
            with: [
                "date": Date.init()
            ]
        )
        button.setTitle("RESET", for: .normal)
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { (timer) in
                self.updateUI()
        })
    }
    
    // MARK: Private Methods
    private func updateUI() {
        descriptionLabel.text = challenge.progressDescription
        updateTime()
    }
    
    private func updateTime() {
        timeLabel.text = String(time)
        timeUnitLabel.text = "second"
        if time > 1 {
            timeUnitLabel.text = "seconds"
        }
    }
    
    private func updateQuote() {
        let quote = Quotes.getRandomQuotes()
        quoteLabel.text = quote.content
        authorLabel.text = quote.author
    }
    
    private func setProgress() {
        progressView.setProgress(with: CGFloat(challenge.progressPercentage))
    }
    
    private func updateColorScheme() {
        self.progressView.updateUI()
        self.view.window?.tintColor = CustomTheme.primaryColor()
        self.view.backgroundColor = CustomTheme.backgroundColor()
        
        // Dark Theme
        descriptionLabel.updateFontColor()
        timeLabel.updateFontColor()
        timeUnitLabel.updateFontColor()
        authorLabel.updateFontColor()
        quoteLabel.updateFontColor()
    }
    
    // MARK: View Controller Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateColorScheme()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgress()
        updateColorScheme()
        if challenge.started {
            button.setTitle("RESET", for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.updateUI()
            })
        }
    }
    
    // MARK: Navigation
    private struct Storyboard {
        static let EditChallenge = "Edit Challenge Segue"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.EditChallenge {
            if let dvc = segue.destination.contentViewController as? AddChallengeTableViewController {
                dvc.challenge = challenge
                dvc.challengeIndex = challengeIndex
            }
        }
    }
}

// MARK: UIViewController Transitioning Delegate Extension
extension CounterViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
}





