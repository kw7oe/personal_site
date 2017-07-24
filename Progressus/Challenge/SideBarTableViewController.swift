//
//  SideBarTableViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 24/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {
    
    var challengeIndex = 0
    var challenge: Challenge {
        if let challenges = Settings.challenges {
            if !challenges.isEmpty {
                return challenges[challengeIndex]
            }
        }
        return Challenge(name: "", date: Date.init(), goal: 7, started: false)
    }
    
    override func viewDidLoad() {
        self.preferredContentSize = CGSize(width: 250, height: 250)
    }


    
    // MARK: - Navigation
    private struct Storyboard {
        static let EditChallenge = "Edit Challenge Segue"
        static let ShowChart = "Show Stats Segue"
    }
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
