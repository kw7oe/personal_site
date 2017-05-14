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
    var maxValue: Int{
        return data.max() ?? 0
    }
    
    var chartHeight: CGFloat {
        return bounds.height * 0.7
    }
    var chartWidth: CGFloat {
        return bounds.width - innerMargin * CGFloat(data.count)
    }
    // The margin between each bar
    var innerMargin: CGFloat {
        return marginPercentage * bounds.width
    }
    // The margin between the yAxis and the first bar
    var outerMargin: CGFloat {
        return innerMargin / 2
    }
    var barWidth: CGFloat {
        return chartWidth / CGFloat(data.count)
    }
    var barHeight: CGFloat {
        return chartHeight / CGFloat(maxValue)
    }
    var minBarHeight: CGFloat = 3.0

    
    convenience init(frame: CGRect, data: [Int]) {
        self.init(frame: frame)
        self.data = data
        drawHorizontalAxisTicks()
        createBarChart()
        drawAxis(startX: bounds.minX, endX: bounds.minX,
                 startY: bounds.height - chartHeight, endY: bounds.height,
                 color: CustomTheme.graphAxisColor())
        drawAxis(startX: bounds.minX, endX: bounds.maxX,
                 startY: bounds.maxY, endY: bounds.maxY,
                 color: CustomTheme.graphAxisColor())
    }
    
    func createBarChart() {
        for i in 0..<data.count {
            let num = data[i]
            let bar = createBar(value: CGFloat(num), index: CGFloat(i));
            layer.addSublayer(bar)
        }
    }
    
    func createBar(value: CGFloat, index: CGFloat) -> CAShapeLayer {
        var height = barHeight * value
        if height == 0 { height = minBarHeight }
        let y = bounds.maxY - height
        let x = index * (barWidth + innerMargin) + outerMargin
        
        let frame = CGRect(x: x, y: y,
                           width: barWidth, height: height)
        let path = UIBezierPath(rect: frame)
        let rectLayer = CAShapeLayer()
        
        rectLayer.path = path.cgPath
        rectLayer.fillColor = CustomTheme.primaryColor().cgColor
        
        return rectLayer
    }
    
    func drawAxis(startX: CGFloat, endX: CGFloat, startY: CGFloat, endY: CGFloat, color: UIColor) {
        let path = UIBezierPath()
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let axisLayer = CAShapeLayer()
        axisLayer.path = path.cgPath
        axisLayer.strokeColor = color.cgColor
        
        layer.addSublayer(axisLayer)
    }
    
    func drawHorizontalAxisTicks() {
        var y = bounds.maxY
        print(maxValue)
        for _ in 1...maxValue {
            y -= barHeight
            drawAxis(startX: bounds.minX, endX: bounds.maxX, startY: y, endY: y, color: CustomTheme.graphTickAxisColor())
        }
    }
    
    func createLabel() {
        
    }
    

}
