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
        self.backgroundColor = Color.backgroundColor
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
        initialLayer.drawProgress(with: path, color: Color.lighterPrimaryColor)
        progressLayer.drawProgress(with: path, color: Color.primaryColor, strokeEnd: 0)
        self.layer.addSublayer(initialLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func setLabelText(with percentage: CGFloat) {
        var percentageText = "100"
        if percentage < 1 {
            percentageText = String.init(format: "%.1f", percentage * 100)
        }
        label.attributedText = styleString(percentageText, unit: "percent")
    }
    
    private func styleString(_ text: String, unit: String) -> NSMutableAttributedString {
        let bold: [String:Any] = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 36)]
        let italic: [String:Any] = [NSFontAttributeName: UIFont.italicSystemFont(ofSize: 16)]
        let result = NSMutableAttributedString()
        let string = NSMutableAttributedString(string: "\(text)\n", attributes: bold)
        let unitString = NSMutableAttributedString(string: unit, attributes: italic)
        result.append(string)
        result.append(unitString)
        return result
    }
    
    private func setupLabel(at position: CGPoint) {
        label.frame = frame
        label.textAlignment = .center
        label.numberOfLines = 2
        label.center = position
        label.updateFontColor()
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
