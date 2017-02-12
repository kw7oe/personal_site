//
//  Products.swift
//  Progressus
//
//  Created by Choong Kai Wern on 12/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

public struct Products {
    
    public static let DarkTheme = "dt_01"
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [
        Products.DarkTheme
    ]
    
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
    
}
