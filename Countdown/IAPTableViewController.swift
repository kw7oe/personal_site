//
//  IAPTableViewController.swift
//  Progressus
//
//  Created by Choong Kai Wern on 11/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import StoreKit

class IAPTableViewController: UITableViewController {

    var products = [SKProduct]()
    var spinner: UIActivityIndicatorView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "In-App Purchase"
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(IAPTableViewController.reload), for: .valueChanged)
        
        let restoreButton = UIBarButtonItem(
            title: "Restore",
            style: .plain,
            target: self,
            action: #selector(IAPTableViewController.restoreTapped(_:)))
        navigationItem.rightBarButtonItem = restoreButton
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(IAPTableViewController.handlePurchaseNotification(_:)),
            name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
            object: nil)
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.color = CustomTheme.textColor()
        tableView.backgroundView = spinner
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = CustomTheme.backgroundColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.separatorStyle = .none
        spinner.startAnimating()
        reload()
    }
    
    // Methods 
    func reload() {
        products = []
        tableView.reloadData()
        
        Products.store.requestProducts { (success, products) in
            if success {
                self.products = products!
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
            self.tableView.separatorStyle = .singleLine
            if self.spinner.isAnimating {
                self.spinner.stopAnimating()
            }
        }
    }
    
    func restoreTapped(_ sender: AnyObject) {
        Products.store.restorePurchased()
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for(index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }

}

// MARK: - Table view data source
extension IAPTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
        
        let product = products[indexPath.row]
        
        if let productCell = cell as? ProductTableViewCell {
            productCell.black()
            productCell.product = product
            productCell.buyButtonHandler = { product in
                Products.store.buyProduct(product)
            }
        }
        
        return cell
    }

}
