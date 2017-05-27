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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawBarChart()
        setupDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomTheme.backgroundColor()
        title = challenge.name
    }
    
    private func drawBarChart() {
        if barChartView != nil {
            barChartView?.removeFromSuperview()
        }
        
        let frame = CGRect(x: view.bounds.minX, y: view.bounds.minY + topMargin!,
                           width: view.bounds.width, height: view.bounds.height / 2.5)
        
        barChartView = BarChartView.init(frame: frame, data: data)
        view.addSubview(barChartView!)
    }
    
    private func setupDetailsView() {
        initializeDetailsView()
        let bestLabel = createLabelWith(text: "Best: \(data.max() ?? 0)")
        let worstLabel = createLabelWith(text: "Worst: \(data.min() ?? 0)")
        
        let sum = data.reduce(0) { (a, b) -> Int in
            a + b
        }
        let average = Double(sum) / Double(data.count)
        let averageLabel = createLabelWith(text: "Average: \(average)")
        
        let stackView = UIStackView.init(
            arrangedSubviews: [bestLabel, worstLabel, averageLabel]
        )
        stackView.alignment = .center
        stackView.spacing = 10.0
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        detailsView?.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: detailsView!.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: detailsView!.centerYAnchor).isActive = true
        
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
    
    private func createLabelWith(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = CustomTheme.textColor()
        
        
        label.frame = CGRect(origin: CGPoint.zero,
                             size: label.intrinsicContentSize)
        
        return label
    }
    
    
}
