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
        
    }
    
    
}
