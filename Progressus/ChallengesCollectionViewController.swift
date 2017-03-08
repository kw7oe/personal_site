//
//  ChallengesCollectionViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 05/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Challenge Cell"

class ChallengesCollectionViewController: UICollectionViewController {
    
    private struct Storyboard {
        static let ChallengeCellSegue = "Challenge Cell Segue"
        static let SettingsSegue = "Settings Segue"
        static let AddChallengeSegue = "Add Challenge Segue"
    }
    
    var challenges: [Challenge]? {
        return Settings.challenges
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()        
        updateColorScheme()
    }
    
    private func updateColorScheme() {        
        self.navigationController?.navigationBar.none()
        self.collectionView?.window?.tintColor = CustomTheme.primaryColor() // Bugs
        self.collectionView?.backgroundColor = CustomTheme.backgroundColor()
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challenges?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let challengeCell = cell as? ChallengeCollectionViewCell {
            challengeCell.challenge = challenges?[indexPath.row]
        }        
        return cell
    }
    
    
    // MARK: Navigation 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ChallengeCellSegue {
            if let vc = segue.destination as? CounterViewController {
                if let cell = sender as? ChallengeCollectionViewCell {
                    let index = collectionView?.indexPath(for: cell)
                    vc.challengeIndex = index!.row
                }
            }
        }
    }
}

extension ChallengesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width - 30, height: 97)
    }
}
