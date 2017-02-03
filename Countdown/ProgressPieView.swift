//
//  ProgressPieView.swift
//  Countdown
//
//  Created by Choong Kai Wern on 28/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ProgressPieView: UIView {
    
    let progressLayer = CAShapeLayer()
    private let initialLayer = CAShapeLayer()
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY - bounds.width / 12)
        let path = UIBezierPath(arcCenter: center , radius: bounds.width / 4, startAngle: CGFloat(-M_PI/2), endAngle: CGFloat(3*M_PI/2), clockwise: true)
        
        initialLayer.path = path.cgPath
        initialLayer.strokeColor = UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 0.5).cgColor
        initialLayer.fillColor = UIColor.clear.cgColor
        initialLayer.lineWidth = 10
        
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 1).cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 10
        progressLayer.strokeEnd = 0
        
        self.layer.addSublayer(initialLayer)
        self.layer.addSublayer(progressLayer)
        
        setupLabel()
        label.center = center
    }
    
    // MARK: Public Method
    func setProgress(with percentage: CGFloat) {
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.duration = 1.3
        endAnimation.toValue = percentage
        endAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        endAnimation.fillMode = kCAFillModeBoth
        endAnimation.isRemovedOnCompletion = false
        progressLayer.add(endAnimation, forKey: nil)
        
        var percentageText = "100"
        if percentage < 1 {
            percentageText = String.init(format: "%.1f", percentage * 100)
        }
        
        label.text = "\(percentageText)\n percent"
    }
    
    // MARK: Private Method
    private func setupLabel() {
        label.frame = frame
        label.textAlignment = .center
        label.numberOfLines = 2
        addSubview(label)
    }
}
