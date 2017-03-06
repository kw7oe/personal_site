//
//  ChallengeCollectionViewCell.swift
//  Progressus
//
//  Created by Choong Kai Wern on 05/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ChallengeCollectionViewCell: UICollectionViewCell {
    var challenge: Challenge! {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    func updateUI() {
        challengeNameLabel.text = challenge.name
        dayTimeLabel.text = challenge.progressDescription
        percentageLabel.text = challenge.progressPercentageString + "%"
        customize()
    }
    
    func customize() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.init(white: 0.98, alpha: 1).cgColor, UIColor.init(white: 0.9, alpha: 1).cgColor]
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(white: 0.9, alpha: 1).cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add Line between percentage and description
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: percentageLabel.frame.minX + 20 , y: 0))
//        path.addLine(to: CGPoint(x:  percentageLabel.frame.minX + 20, y: self.bounds.maxY))
//        print(path)
//        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = UIColor.init(white: 0.8, alpha: 1).cgColor
//        shapeLayer.lineWidth = 1.0
//        self.layer.addSublayer(shapeLayer)
    }
}
