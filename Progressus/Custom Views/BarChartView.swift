//
//  BarChartView.swift
//  Progressus
//
//  Created by Choong Kai Wern on 13/05/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class BarChartView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var data: [Int]!
    var marginPercentage: CGFloat = 0.03
    
    var margin: CGFloat {
        return marginPercentage * bounds.width
    }
    var barWidth: CGFloat {
        return bounds.width / CGFloat(data.count) - margin
    }
    var barHeight: CGFloat {
        return bounds.height * 0.7 / CGFloat(data.max()!)
    }

    
    convenience init(frame: CGRect, data: [Int]) {
        self.init(frame: frame)
        self.data = data
        createBarChart()
    }
    
    func createBarChart() {
        for i in 0..<data.count {
            let num = data[i]
            let bar = createBar(value: CGFloat(num), index: CGFloat(i));
            layer.addSublayer(bar)
        }
    }
    
    func createBar(value: CGFloat, index: CGFloat) -> CAShapeLayer {
        let height = barHeight * value + 5
        let y = bounds.maxY - height
        let x = index * (barWidth + margin)
        
        let frame = CGRect(x: x, y: y,
                           width: barWidth, height: height)
        let path = UIBezierPath(rect: frame)
        let rectLayer = CAShapeLayer()
        
        rectLayer.path = path.cgPath
        rectLayer.fillColor = CustomTheme.lighterPrimaryColor().cgColor
        rectLayer.borderColor = CustomTheme.primaryColor().cgColor
        rectLayer.borderWidth = 1.0
        
        return rectLayer
    }
    
    func createXAxis(_ label: String) {
        
    }
    
    func createYAxis(_ label: String) {

    }
    

}
