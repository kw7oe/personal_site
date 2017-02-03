//
//  Quotes.swift
//  Countdown
//
//  Created by Choong Kai Wern on 14/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

// MARK: Quote Model
struct Quote {
    var author: String?
    var content: String
}

struct Quotes {    
    static var quotes: [Quote] = [
        Quote(author: "Og Mandino", content: "Failure will never overtake me if my determination to succeed is strong enough."),
        Quote(author: "Christopher Reeve", content: "Don't Give Up. Don't Lose Hope. Don't Sell Out."),
        Quote(author: "Walter Elliot", content: "Perseverance is not a long race; it is many short races one after the other.")
    ]
    
    static func getRandomQuotes() -> Quote {
        return quotes[Int.random(upperBound: quotes.count)]
    }
}

// MARK: Int Extension 
extension Int {
    static func random(upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
}

