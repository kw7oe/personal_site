//
//  SideBarTableViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 24/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
