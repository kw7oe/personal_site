//
//  StatsViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 28/04/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController {
    
    enum FontStyle {
        case normal
        case bold
        case italic
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var challenge: Challenge!
    var barChartView: BarChartView?
    var detailsView: UIView?
    
    var topMargin: CGFloat? {
        return navigationController?.navigationBar.frame.maxY
    }
    
    var data: [Int] {
        let challenge = try? CDChallenge.findOrCreateChallenge(self.challenge, inContext: container!.viewContext)
        return challenge!.getRecordsDuration()
    }
    
    var average: Double {
        let sum = data.reduce(0) { (a, b) -> Int in
            a + b
        }
        var average: Double = 0
        if (data.count != 0) {
            average = Double(sum) / Double(data.count)
        }
        var precision = 2
        if average == 0 { precision = 1 }
        return Double.init(String.init(format: "%.\(precision)f", average)) ?? 0.0
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawBarChart()
        setupDetailsView()
        
        
        let viewHeight = view.frame.height - topMargin!
        let remainingHeight = (viewHeight - barChartView!.frame.height - detailsView!.frame.height)
        let topY = remainingHeight / 2
        barChartView!.frame = CGRect(
            origin: CGPoint(x: barChartView!.frame.minX, y: barChartView!.frame.minY + topY),
            size: barChartView!.frame.size
        )
        detailsView!.frame = CGRect(
            origin: CGPoint(x: detailsView!.frame.minX, y: barChartView!.frame.maxY),
            size: detailsView!.frame.size
        )
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomTheme.backgroundColor()        
        self.navigationController?.navigationBar.none()
        title = "Stats"
    }
    
    private func drawBarChart() {
        if barChartView != nil {
            barChartView?.removeFromSuperview()
        }
        
        let frame = CGRect(x: view.bounds.minX, y: view.bounds.minY + topMargin!,
                           width: view.bounds.width, height: view.bounds.height / 2.5)
        
        barChartView = BarChartView.init(frame: frame, data: data.minSizeOf(7))
        view.addSubview(barChartView!)
    }
    
    private func setupDetailsView() {
        initializeDetailsView()
        
        let bestStackView = createStatStackView(label: "Best", value: (data.max() ?? 0))
        let averageStackView = createStatStackView(label: "Average", value: average)
        
        let stackView = UIStackView.init(
            arrangedSubviews: [bestStackView, averageStackView]
        )
        
        createHorizontalStackViewFrom(view: stackView)
    }
    
    private func createStatStackView(label: String, value: Numeric) -> UIStackView {
        let label = createLabelWith(text: label, inStyle: .bold, ofSize: 32)
        let valueLabel = createLabelWith(text: "\(value)", inStyle: .normal, ofSize: 24)
        
        let stackView = UIStackView.init(
            arrangedSubviews: [label, valueLabel]
        )
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 15.0
        
        return stackView
    }
    
    private func createHorizontalStackViewFrom(view stackView: UIStackView) {
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        detailsView?.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: detailsView!.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: detailsView!.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: detailsView!.topAnchor, constant: 40.0).isActive = true
    }
    
    private func initializeDetailsView() {
        if (detailsView != nil) {
            detailsView?.removeFromSuperview()
        }
        
        let frame = CGRect(x: view.bounds.minX,
                           y: barChartView?.frame.maxY ?? view.bounds.midY,
                           width: view.bounds.width,
                           height: view.bounds.height / 2.5)
        detailsView = UIView.init(frame: frame)
        view.addSubview(detailsView!)
    }
    
    private func createLabelWith(text: String, inStyle: FontStyle, ofSize: CGFloat) -> UILabel {
        let label = UILabel()
        
        switch inStyle {
        case .bold: label.attributedText = text.boldSystemFont(ofSize: ofSize)
        case .italic: label.attributedText = text.italicSystemFont(ofSize: ofSize)
        default:
            label.text = text
            label.font = label.font.withSize(ofSize)
        }
        
        label.textColor = CustomTheme.textColor()
        label.frame = CGRect(origin: CGPoint.zero,
                             size: label.intrinsicContentSize)
        
        return label
    }
    
}


