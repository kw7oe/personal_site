//
//  BarChartView.swift
//  Progressus
//
//  Created by Choong Kai Wern on 13/05/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class BarChartView: UIView {
    
    var data: [Int]!    
    var xScale: Int = 3
    /**
     The maxmimum value in the y-axis/chart.
    */
    var maxValue: Int{
        let value = data.max() ?? 0
        return value != 0 ? value : 6
    }
    
    /**
     The UILabel width of the `maxValue`.
    */
    var maxValueWidth: CGFloat {
        let label = createLabel(text: String(maxValue))
        return label.intrinsicContentSize.width
    }
    
    var chartHeight: CGFloat {
        return bounds.height * 0.9
    }
    var chartWidth: CGFloat {
        return bounds.width
    }
    /**
     Internal margin of the chart view.
    */
    var chartOffset: CGFloat {
        return chartWidth * 0.025
    }
    var chartAreaHeight: CGFloat {
        return chartHeight - chartOffset * 2
    }
    var chartAreaWidth: CGFloat {
        return chartWidth - chartOffset * 2 - maxValueWidth
    }
    var chartAreaLeft: CGFloat {
        return bounds.minX + chartOffset + maxValueWidth
    }
    var chartAreaRight: CGFloat {
        return bounds.maxX - chartOffset
    }
    var chartAreaBottom: CGFloat {
        return bounds.maxY - chartOffset
    }
    var chartAreaTop: CGFloat {
        return bounds.maxY - chartHeight
    }
    /**
     Bar width not including the internal margin within each bar.
    */
    var barWidth: CGFloat {
        return chartAreaWidth / CGFloat(data.count)
    }
    /**
     Bar width after internal margin is included.
    */
    var actualBarWidth: CGFloat {
        return barWidth - barMargin * 2
    }
    /**
     Bar margin between each bar.
    */
    var barMargin: CGFloat {
        return barWidth * 0.15
    }
    /**
     The bar height represented by a single unit/value.
     To get the total height for a bar chart:
     ```
     let height = barHeight * value
     ```
    */
    var barHeight: CGFloat {
        return chartAreaHeight / CGFloat(maxValue)
    }
    
    /**
     The minimum bar height when the value is 0.
    */
    var minBarHeight: CGFloat = 3.0
    
    // MARK:
    
    convenience init(frame: CGRect, data: [Int], margin: CGFloat = 0.1) {
        
        // Left and Right Margin
        let margin = frame.width * margin
        self.init(frame:
            CGRect(x: frame.minX + margin,
                   y: frame.minY,
                   width: frame.width - margin * 2,
                   height: frame.height)
        )
        
        self.data = data
        
        // If Data is empty, Create a Blank View
        if data.isEmpty {
            let blankView = BlankView.init(frame: bounds,
                                           title: "No Data Available",
                                           detail: nil)
            addSubview(blankView)
        } else {
            updateUI()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = CustomTheme.backgroundColor()
    }
    
    private func updateUI() {
        
        drawHorizontalAxisTicks()
        drawVerticalAxisTicks()
        createBarChart()
        
        // X-Axis
        drawAxis(startX: bounds.minX + chartOffset, endX: bounds.maxX,
                 startY: chartAreaBottom, endY: chartAreaBottom,
                 color: CustomTheme.graphTickAxisColor())
    }
    
    private func createBarChart() {
        for i in 0..<data.count {
            let num = data[i]
            let bar = createBar(value: CGFloat(num), index: CGFloat(i));
            layer.addSublayer(bar)
        }
    }
    
    private func createBar(value: CGFloat, index: CGFloat) -> CAShapeLayer {
        var height = barHeight * value
        if height == 0 { height = minBarHeight }
        
        let x = (index * barWidth) + barMargin + chartOffset + maxValueWidth
        
        // CAShapeLAyer
        let frame = CGRect(x: x, y: chartAreaBottom - height,
                           width: actualBarWidth, height: height)
        let path = UIBezierPath(rect: frame)
        let rectLayer = CAShapeLayer()
        
        rectLayer.path = path.cgPath
        rectLayer.fillColor = CustomTheme.primaryColor().cgColor
        
        return rectLayer
    }
       
    private func drawHorizontalAxisTicks() {
        var y = chartAreaBottom
        let interval: CGFloat = CGFloat(maxValue) / CGFloat(xScale)
        
        for i in 1...xScale {
            y -= barHeight * CGFloat(interval)
            drawAxis(startX: chartAreaLeft, endX: chartAreaRight, startY: y, endY: y, color: CustomTheme.graphTickAxisColor())
            createYLabel(x: chartAreaLeft, y: y, value: String.init(format: "%.1f", CGFloat(i) * interval))
        }
    }
    
    private func drawVerticalAxisTicks() {
        var x = chartAreaLeft
        
        for _ in 0...data.count {
            drawAxis(startX: x, endX: x, startY: chartAreaTop, endY: chartAreaBottom, color: CustomTheme.graphTickAxisColor())
            x += barWidth
        }
    }
    
    // Refactoring Needed
    private func createXLabel(x: CGFloat, y: CGFloat, value: String, maxWidth: CGFloat) {
        let label = createLabel(text: value)
        let size = label.intrinsicContentSize
        
        // Max Width refer to the widest label in the axis, E.g. "32"
        // To calculate the offset needed so the label is aligned in center
        let offset = (maxWidth - size.width) / 2
        let startX = x + offset
        
        let frame = CGRect(x: startX, y: y + chartOffset,
                           width: size.width, height: size.height)
        label.frame = frame
        
        addSubview(label)
    }
    
    private func createYLabel(x: CGFloat, y: CGFloat, value: String) {
        let label = createLabel(text: value)
        let size = label.intrinsicContentSize
        
        var offset = chartOffset
        offset += size.width + (maxValueWidth - size.width) / 2
        let startX = x - offset
        let frame = CGRect(x: startX, y: y - size.height / 2,
                           width: size.width, height: size.height)
        label.frame = frame
        
        addSubview(label)
    }
    
    // MARK: Helper Methods
    private func drawAxis(startX: CGFloat, endX: CGFloat, startY: CGFloat, endY: CGFloat, color: UIColor) {
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
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = CustomTheme.textColor()
        label.textAlignment = .center
        label.font = label.font.withSize(12.0)
        
        return label
    }
    

}
