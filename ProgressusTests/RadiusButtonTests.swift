//
//  RadiusButtonTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 08/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus
class RadiusButtonTests: XCTestCase {
        
    func testLayoutSubviews() {
        let button = RadiusButton()
        button.setNeedsLayout()
        button.layoutIfNeeded()
        
        XCTAssertEqual(button.layer.cornerRadius, 18.0)
        XCTAssertEqual(button.layer.shadowRadius, 5.0)
        XCTAssertEqual(button.backgroundColor, CustomTheme.primaryColor())
    }
    
    
}
