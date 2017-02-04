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
        setProgressLayer(with: path)
        setupLabel(at: center)
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
        setLabelText(with: percentage)
    }
    
    // MARK: Private Method
    private func setProgressLayer(with path: UIBezierPath) {
        initialLayer.drawProgress(with: path, color: UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 0.5))
        progressLayer.drawProgress(with: path, color:  UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 1), strokeEnd: 0)
        self.layer.addSublayer(initialLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func setLabelText(with percentage: CGFloat) {
        var percentageText = "100"
        if percentage < 1 {
            percentageText = String.init(format: "%.1f", percentage * 100)
        }
        label.text = "\(percentageText)\n percent"
    }
    
    private func setupLabel(at position: CGPoint) {
        label.frame = frame
        label.textAlignment = .center
        label.numberOfLines = 2
        label.center = position
        addSubview(label)
    }
}

// CAShapeLayer Extension
extension CAShapeLayer {
    func drawProgress(with path: UIBezierPath, color: UIColor, strokeEnd: CGFloat = 1) {
        self.path = path.cgPath
        self.strokeColor = color.cgColor
        self.lineWidth = 10
        self.fillColor = UIColor.clear.cgColor
        self.strokeEnd = strokeEnd
    }
}
