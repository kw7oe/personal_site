//
//  ChallengeTableViewCell.swift
//  Progressus
//
//  Created by Choong Kai Wern on 12/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {
    
    var challenge: Challenge! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var dayTimeLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    func updateUI() {
        challengeNameLabel.text = challenge.name
        dayTimeLabel.text = challenge.progressDescription
        percentageLabel.text = challenge.progressPercentageString + "%"
        customize()
    }
    
    override func customize() {
        backgroundColor = CustomTheme.cellBackgroundColor()
        selectedBackgroundView = CustomTheme.cellSelectedView()
        contentView.layoutMargins.left = 25
        contentView.layoutMargins.right = 25
        challengeNameLabel.textColor = CustomTheme.textColor()
        percentageLabel.textColor = CustomTheme.textColor()
        dayTimeLabel.textColor = CustomTheme.textColor()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
