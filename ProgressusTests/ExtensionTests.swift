//
//  ExtensionTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 20/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class ExtensionTests: XCTestCase {
    
    func testArrayPrepend() {
        var array = [1,2,3]
        array.prepend(element: 0)
        XCTAssertEqual(array.first!, 0)
    }
    
    func testArrayMinSizeOf() {
        let array = [1,2,3]
        XCTAssertEqual([0,0,1,2,3], array.minSizeOf(5))
        
        // When array size is larger than N
        let array2 = [1,2,3,4,5]
        XCTAssertEqual([1,2,3,4,5], array2.minSizeOf(5))
    }

    
    func testIntRandome() {
        let a = Int.random(upperBound: 5)
        XCTAssert(a < 5)
    }
    
    func testStringPluralize() {
        XCTAssertEqual("  dogs  ", String.pluralize(2, input: "dog"))
        XCTAssertEqual("  dog  ", String.pluralize(1, input: "dog"))
    }
    
    func testStringToSystemFont() {
        convertAndAssertStringTo("italic")
        convertAndAssertStringTo("bold")
    }
    
    func convertAndAssertStringTo(_ attribute: String) {
        var font: NSAttributedString
        if attribute == "bold" {
            font = "string".boldSystemFont(ofSize: 16)
        } else {
            font = "string".italicSystemFont(ofSize: 16)
        }
        
        if attribute == "italic" {
            XCTAssert(font.debugDescription.contains("font-style: italic"))
        } else {
            XCTAssert(font.debugDescription.contains("font-weight: bold"))
        }
        
        XCTAssert(font.debugDescription.contains("font-size: 16.0"))
    }
    
    
}
