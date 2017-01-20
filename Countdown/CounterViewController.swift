//
//  ViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 10/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    
    var time: Int {
        return -Int(Settings.date.timeIntervalSinceNow)
    }
    
    var timer = Timer()
    
    
    // MARK : View
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeUnitLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // TODO: Add in Animation
    private func updateUI() {
        updateTime()
        updateDescription()
    }
    
    private func updateTime() {
        timeLabel.text = String(time)
        timeUnitLabel.text = "second"
        if time > 1 {
            timeUnitLabel.text = "seconds"
        }
    }
    
    private func updateDescription() {
        let results = Parser.parseToArray(time: time, basedOn: Parser.Format.DayHour)
        let attr: [String:Any] = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22.5)]
        let description = NSMutableAttributedString()
        
        for result in results {
            let timeString = NSMutableAttributedString(string: "\(result.time)", attributes: attr)
            let unitString = NSMutableAttributedString(string: result.unit)
            description.append(timeString)
            description.append(unitString)
        }
        descriptionLabel.attributedText = description
    }
    
    private func updateQuote() {
        let quote = Quotes.getRandomQuotes()
        quoteLabel.text = quote.content
        authorLabel.text = quote.author 
    }
    
    @IBAction func resetTime(_ sender: UIButton) {
        
        // Code Smell: Code Duplication
        let alertController = UIAlertController(title: "Are you sure you want to reset?", message: nil, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (action) in
                    Settings.date = Date.init()
                    self.updateUI()
                }
            )
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: View Controller Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let navigationBar =  self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar?.barTintColor = UIColor.white
        navigationBar?.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        
        updateUI()
        updateQuote()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateUI()
        })
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
}



