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
}

extension ChallengesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width - 30, height: 97)
    }
}
