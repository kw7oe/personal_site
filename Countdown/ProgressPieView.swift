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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let path = UIBezierPath(arcCenter: self.center , radius: frame.width / 4, startAngle: CGFloat(-M_PI/2), endAngle: CGFloat(3*M_PI/2), clockwise: true)
        
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
    }
    
    func setProgress(with percentage: CGFloat) {
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.duration = 1.3
        endAnimation.toValue = percentage
        endAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        endAnimation.fillMode = kCAFillModeBoth
        endAnimation.isRemovedOnCompletion = false
        progressLayer.add(endAnimation, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
