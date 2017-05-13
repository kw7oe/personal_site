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
    
    var data: [Int] {
        let challenge = try? CDChallenge.findOrCreateChallenge(self.challenge, inContext: container!.viewContext)
        return challenge!.getRecordsDuration()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomTheme.backgroundColor()
        createBarChart()        
    }
    
    func createBarChart() {
        let margin: CGFloat = 20.0
        let frame = CGRect(x: view.bounds.minX + margin, y: view.bounds.minY,
                           width: view.bounds.width - margin * 2, height: view.bounds.height / 2)
        let barChartView = BarChartView.init(frame: frame, data: data)       
        view.addSubview(barChartView)
    }
    
    
}
