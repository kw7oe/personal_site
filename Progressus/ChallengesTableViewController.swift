//
//  ChallengesTableViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 12/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ChallengesTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let ChallengeCellSegue = "Challenge Cell Segue"
        static let SettingsSegue = "Settings Segue"
        static let AddChallengeSegue = "Add Challenge Segue"
    }
    
    var challenges: [Challenge]? {
        return Settings.challenges
    }
    var blankView: BlankView!
    
    private func updateColorScheme() {
        navigationController?.navigationBar.none()
        view.window?.tintColor = CustomTheme.primaryColor()
        tableView.backgroundColor = CustomTheme.backgroundColor()
    }
    
    // MARK: View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()        
        updateColorScheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blankView = BlankView(
            frame: tableView.frame,
            title: "No Challenge Available",
            detail: "You can add up to 4 challenges."
        )
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ChallengeCellSegue {            if let vc = segue.destination as? CounterViewController {
                if let cell = sender as? ChallengeTableViewCell {
                    let index = tableView?.indexPath(for: cell)
                    vc.challengeIndex = index!.section
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.AddChallengeSegue {
            if let count = Settings.challenges?.count, count >= 4 {
                let alertController = UIAlertController(title: "Note", message: "You can only add a maximum amount of 4 challenges. Less is more.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                present(alertController, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}

// MARK: Table View Data Source
extension ChallengesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if challenges == nil || challenges?.count == 0 {
            tableView.backgroundView = blankView
        } else {
            tableView.backgroundView = nil
            return challenges!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Challenge Cell", for: indexPath)
        
        if let challengeCell = cell as? ChallengeTableViewCell {
            challengeCell.challenge = challenges?[indexPath.section]
        }
        
        return cell
    }
    
    // Editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle  {
        case .delete:
            let index = indexPath.section
            Settings.removeChallenge(at: index)
            tableView.deleteSections(IndexSet([index]), with: .fade)
        default: break
        }
    }
}
