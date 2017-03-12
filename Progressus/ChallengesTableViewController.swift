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
    
    private func updateColorScheme() {
        navigationController?.navigationBar.none()
        view.window?.tintColor = CustomTheme.primaryColor()
        tableView.backgroundColor = CustomTheme.backgroundColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()        
        updateColorScheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .none
        tableView.reloadData()
    }

    // MARK: Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return challenges?.count ?? 0
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
    
    // MARK: Table View Delegate
    
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ChallengeCellSegue {
            if let vc = segue.destination as? CounterViewController {
                if let cell = sender as? ChallengeTableViewCell {
                    let index = tableView?.indexPath(for: cell)
                    vc.challengeIndex = index!.section
                }
            }
        }
    }
    

}
