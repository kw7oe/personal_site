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
    
    var chartHeight: CGFloat {
        return bounds.height * 0.7
    }
    var chartWidth: CGFloat {
        return bounds.width - margin * CGFloat(data.count)
    }
    var margin: CGFloat {
        return marginPercentage * bounds.width
    }
    var barWidth: CGFloat {
        return chartWidth / CGFloat(data.count)
    }
    var barHeight: CGFloat {
        return chartHeight / CGFloat(data.max()!)
    }

    
    convenience init(frame: CGRect, data: [Int]) {
        self.init(frame: frame)
        self.data = data
        createBarChart()
        drawAxis(startX: bounds.minX, endX: bounds.minX,
                 startY: bounds.height - chartHeight, endY: bounds.height)
        drawAxis(startX: bounds.minX, endX: bounds.maxX,
                 startY: bounds.maxY, endY: bounds.maxY)
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
        rectLayer.strokeColor = CustomTheme.primaryColor().cgColor
        rectLayer.lineWidth = 2.0
        
        return rectLayer
    }
    
    func drawAxis(startX: CGFloat, endX: CGFloat, startY: CGFloat, endY: CGFloat) {
        let path = UIBezierPath()
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let axisLayer = CAShapeLayer()
        axisLayer.path = path.cgPath
        axisLayer.strokeColor = CustomTheme.placeholderColor().cgColor
        
        layer.addSublayer(axisLayer)
    }
    
    func drawXAxisTicks() {
        
    }
    
    func createLabel() {
        
    }
    

}
