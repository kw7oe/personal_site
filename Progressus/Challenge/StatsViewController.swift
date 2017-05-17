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
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChartView.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomTheme.backgroundColor()
        barChartView.data = data
    }
    
    
}
