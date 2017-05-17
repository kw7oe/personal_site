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
        return bounds.height * 0.9
    }
    var chartWidth: CGFloat {
        return bounds.width
    }
    var chartOffset: CGFloat {
        return chartWidth * 0.025
    }
    var chartAreaHeight: CGFloat {
        return chartHeight - chartOffset * 2
    }
    var chartAreaWidth: CGFloat {
        return chartWidth - chartOffset * 2
    }
    var chartAreaMinX: CGFloat {
        return bounds.minX + chartOffset
    }
    var chartAreaMaxX: CGFloat {
        return bounds.maxX - chartOffset
    }
    var chartAreaMaxY: CGFloat {
        return bounds.maxY - chartOffset
    }
    var chartAreaMinY: CGFloat {
        return bounds.maxY - chartHeight
    }
    var barWidth: CGFloat {
        return chartAreaWidth / CGFloat(data.count)
    }
    var actualBarWidth: CGFloat {
        return barWidth - barMargin * 2
    }
    var barMargin: CGFloat {
        return barWidth * 0.15
    }
    var barHeight: CGFloat {
        return chartAreaHeight / CGFloat(maxValue)
    }
    var minBarHeight: CGFloat = 3.0

    func updateUI() {
        backgroundColor = CustomTheme.backgroundColor()
        drawHorizontalAxisTicks()
        drawVerticalAxisTicks()
        createBarChart()
        
        // Y-Axis
        drawAxis(startX: chartAreaMinX, endX: chartAreaMinX,
                 startY: chartAreaMinY, endY: bounds.maxY,
                 color: CustomTheme.graphAxisColor())
        
        // X-Axis
        drawAxis(startX: bounds.minX, endX: bounds.maxX,
                 startY: chartAreaMaxY, endY: chartAreaMaxY,
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
        
        let x = (index * barWidth) + barMargin + chartOffset
        
        createXLabel(x: x, y: chartAreaMaxY, value: String(Int(index+1)), maxWidth: actualBarWidth)
        
        // CAShapeLAyer
        let frame = CGRect(x: x, y: chartAreaMaxY - height,
                           width: actualBarWidth, height: height)
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
        var y = chartAreaMaxY
        
        let label = UILabel()
        label.text = String(maxValue)
        let maxWidth = label.intrinsicContentSize.width
        
        let interval = maxValue / 6
        
        for i in 1...6 {
            y -= barHeight * CGFloat(interval)
            drawAxis(startX: chartAreaMinX, endX: bounds.maxX, startY: y, endY: y, color: CustomTheme.graphTickAxisColor())
            createYLabel(x: chartAreaMinX, y: y, value: String(i * interval), maxWidth: maxWidth)
        }
    }
    
    func drawVerticalAxisTicks() {
        var x = chartAreaMinX
        
        for _ in 1...data.count {
            x += barWidth
            drawAxis(startX: x, endX: x, startY: chartAreaMinY, endY: chartAreaMaxY, color: CustomTheme.graphTickAxisColor())
        }
    }
    
    // Refactoring Needed
    func createXLabel(x: CGFloat, y: CGFloat, value: String, maxWidth: CGFloat) {
        let label = UILabel()
        label.text = value
        label.textAlignment = .center
        label.textColor = CustomTheme.textColor()
        
        let size = label.intrinsicContentSize
        
        let offset = (maxWidth - size.width) / 2
        
        let startX = x + offset
        let frame = CGRect(x: startX, y: y + chartOffset,
                           width: size.width, height: size.height)
        label.frame = frame
        
        addSubview(label)
    }
    
    func createYLabel(x: CGFloat, y: CGFloat, value: String, maxWidth: CGFloat) {
        let label = UILabel()
        label.text = value
        label.textAlignment = .center
        label.textColor = CustomTheme.textColor()
        
        let size = label.intrinsicContentSize
        
        var offset = chartOffset
        offset += size.width + (maxWidth - size.width) / 2
    
        let startX = x - offset
        let frame = CGRect(x: startX, y: y - size.height / 2,
                           width: size.width, height: size.height)
        label.frame = frame
        
        addSubview(label)
    }
    

}
