//
//  QuoteTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 20/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class QuoteTests: XCTestCase {
    
    func testQuotesMoreThanOne() {
        XCTAssert(Quotes.quotes.count > 0)
    }
    
    func testGetRandomQuuotes() {
        let quote = Quotes.getRandomQuotes()
        XCTAssert(quote.author != nil)
        XCTAssertFalse(quote.content.isEmpty)
    }
 
    
}
