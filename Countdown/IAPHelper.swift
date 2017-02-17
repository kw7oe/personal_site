//
//  IAPHelper.swift
//  Progressus
//
//  Created by Choong Kai Wern on 12/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class IAPHelper: NSObject {
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
            }
        }
        
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: StoreKit API
extension IAPHelper {
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchased() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
}

// MARK: SKProductsRequest Delegate
extension IAPHelper: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
//        for p in products {
//            print("Found product: \(p.productIdentifier)")
//        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Falied to load list of products")
//        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false,nil)
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: SKPaymentTransactionObserver 
extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else {return}
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription)")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: identifier)
    }
}
