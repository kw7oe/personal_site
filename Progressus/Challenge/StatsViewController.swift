//
//  StatsViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 28/04/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import CoreData
import Charts

class StatsViewController: UIViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var data: [Int] {
        return CDChallenge.getRecordsDuration(inContext: container!.viewContext)
    }
    
    @IBOutlet weak var chartView: BarChartView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CDChallenge.printData(inContext: container!.viewContext)
        
        var chartDataEntry = [BarChartDataEntry]()
        for i in 0..<data.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(data[i]))
            chartDataEntry.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: chartDataEntry, label: "Days")
        chartView.data = BarChartData(dataSet: chartDataSet)
        view.addSubview(chartView)
    }
    
    
}
