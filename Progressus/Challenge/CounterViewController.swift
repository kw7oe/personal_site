//
//  ViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 10/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import CoreData

class CounterViewController: UIViewController {
    
    var challengeIndex = 0 
    var challenge: Challenge {
        if let challenges = Settings.challenges {
            if !challenges.isEmpty {
                return challenges[challengeIndex]
            }
        }
        return Challenge(name: "", date: Date.init(), goal: 7, started: false)
    }
    
    var time: Int {
        if !challenge.started { return 0 }
        return -Int(challenge.date.timeIntervalSinceNow)
    }    
    var timer = Timer()
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    // MARK : View Outlet
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var button: RadiusButton!
    @IBOutlet weak var timeUnitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: ProgressPieView! 
    
    // MARK: Target Action
    @IBAction func deleteChallenge(_ sender: UIBarButtonItem) {
        let alertController = createDestrutiveAlert(title: "Delete Challenge") { (action) in
            Settings.removeChallenge(at: self.challengeIndex)
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertController.transitioningDelegate = self
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func resetTime(_ sender: UIButton) {
        if challenge.started {
            resetTimer()
        } else {
            startTimer()
        }
    }
       
    private func resetTimer() {

        let alertController = createDestrutiveAlert(title: "Reset Challenge") { (action) in
            var title = "START"
            if Settings.startOnReset {
                title = "RESET"
            }
            self.updateCoreData()
            self.challenge.update(
                at: self.challengeIndex,
                with: [
                    "date": Date.init(),
                    "started": Settings.startOnReset
                ]
            )
            self.button.setTitle(title, for: .normal)
            self.setProgress()
            self.updateUI()
        }
        
        alertController.transitioningDelegate = self
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
    private func createDestrutiveAlert(title: String, completionHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: "Are you sure? This action cannot be undone.",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "YES",
                style: .destructive,
                handler: completionHandler
            )
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.view.tintColor = CustomTheme.defaultTintColor()
        return alertController
    }
    
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
    
    private func updateCoreData() {
        if let context = container?.viewContext {
            _ = CDRecord.createRecord(challenge, inContext: context)
            
            do {
                try context.save()
            } catch {
                print("Error: ")
                print(error)
            }
        }
        
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    // MARK: Navigation
    private struct Storyboard {
        static let EditChallenge = "Edit Challenge Segue"
        static let ShowChart = "Show Chart Segue"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.EditChallenge {
            if let dvc = segue.destination.contentViewController as? AddChallengeTableViewController {
                dvc.challenge = challenge
                dvc.challengeIndex = challengeIndex
            }
        } else if segue.identifier == Storyboard.ShowChart {
            if let dvc = segue.destination.contentViewController as? StatsViewController {
                dvc.challenge = challenge
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





