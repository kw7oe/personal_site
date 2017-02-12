//
//  ProductTableViewCell.swift
//  Progressus
//
//  Created by Choong Kai Wern on 11/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import StoreKit

class ProductTableViewCell: UITableViewCell {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()


    var buyButtonHandler: ((_ product: SKProduct) -> ())?
    

    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            textLabel?.text = product.localizedTitle
            
            
            if Products.store.isProductPurchased(product.productIdentifier) {
                accessoryType = .checkmark
                accessoryView = nil
                detailTextLabel?.text = ""
            } else if IAPHelper.canMakePayments() {
                detailTextLabel?.text = ProductTableViewCell.priceFormatter.string(from: product.price)
                
                accessoryType = .none
                accessoryView = self.newBuyButton()
            } else {
                detailTextLabel?.text = "Not Available"
            }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryView = nil
    }
    
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(tintColor, for: UIControlState())
        button.setTitle("Buy", for: UIControlState())
        button.addTarget(self, action: #selector(ProductTableViewCell.buyButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return button
    }
    
    func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!)
    }
}
