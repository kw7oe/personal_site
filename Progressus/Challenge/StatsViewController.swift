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
    
    var data: [Int] {
        let challenge = try? CDChallenge.findOrCreateChallenge(self.challenge, inContext: container!.viewContext)
        return challenge!.getRecordsDuration()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawBarChart()
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
        let topMargin = navigationController?.navigationBar.frame.maxY
        let frame = CGRect(x: view.bounds.minX, y: view.bounds.minY + topMargin!,
                           width: view.bounds.width, height: view.bounds.height / 2.5)
        
        barChartView = BarChartView.init(frame: frame, data: data)
        view.addSubview(barChartView!)
    }
    
    
}
