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
    
    var context = AppDelegate.container.viewContext
    var challenge: CDChallenge!
    
    var timer = Timer()
    
    
    // MARK: View Outlet
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var button: RadiusButton!
    @IBOutlet weak var timeUnitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: ProgressPieView!
    
    // MARK: Storyboard Segue
    private struct Storyboard {
        static let EditSegue = "Edit Segue"
    }
    
    // MARK: Target Action

    @IBAction func moreOptions(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.addAction(
            UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: Storyboard.EditSegue, sender: self)
            })
        )
        alertController.addAction(
            UIAlertAction(title: "Delete Challege", style: .destructive, handler: { (action) in
                self.deleteChallenge()
            })
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.view.tintColor = CustomTheme.defaultTintColor()
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteChallenge() {
        let alertController = UIAlertController.destrutiveAlert(title: "Delete Challenge") { (action) in
            _ = CDChallenge.deleteChallenge(inContext: self.context, unique: self.challenge.unique!)
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
    
    // MARK: Private Methods
    private func resetTimer() {

        let alertController = UIAlertController.destrutiveAlert(title: "Reset Challenge") { (action) in
            var title = "START"
            if Settings.startOnReset {
                title = "RESET"
            }
            self.challenge.date = NSDate.init()
            self.challenge.started = Settings.startOnReset
            
            self.saveContext()

            self.button.setTitle(title, for: .normal)
            self.setProgress()
            self.updateUI()
        }
        
        alertController.transitioningDelegate = self
        present(alertController, animated: true, completion: nil)
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func startTimer() {
        challenge.date = NSDate.init()
        challenge.started = true
        
        saveContext()

        button.setTitle("RESET", for: .normal)
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { (timer) in
                self.updateUI()
        })
    }
    
    private func updateUI() {
        descriptionLabel.text = challenge.progressDescription
        updateTime()
    }
    
    private func updateTime() {
        timeLabel.text = String(challenge.time)
        timeUnitLabel.text = "second"
        if challenge.time > 1 {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.EditSegue {
            if let dvc = segue.destination.contentViewController as? AddChallengeTableViewController {
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





