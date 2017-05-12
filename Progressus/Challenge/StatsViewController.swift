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
    
    var data: [Int] {
        return CDChallenge.getRecordsDuration(inContext: container!.viewContext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CDChallenge.printData(inContext: container!.viewContext)
        var x = 0
        for num in data {
            let label = UILabel()
            label.frame = CGRect(x: x, y: 100, width: 30, height: 30)
            label.text = String(num)
            view.addSubview(label)
            x += 30
        }
    }
    
    
}
