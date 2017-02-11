//
//  Extension.swift
//  Progressus
//
//  Created by Choong Kai Wern on 11/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation
import UIKit


// MARK: Array Extension
extension Array {
    mutating func prepend(element: Element) {
        self.insert(element, at: 0)
    }
}
// MARK: Int Extension
extension Int {
    static func random(upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
}

// MARK: String Extension
extension String {
    static func pluralize(_ number: Int, input: String) -> String {
        var string = "  " + input
        if number > 1 {
            string += "s"
        }
        return string + "  "
    }
}
// MARK: UIKit Extension
extension UINavigationBar {
    /**
     Remove Background and Bottom Border of Nagivation Bar
     */
    func none() {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.barTintColor = UIColor.white
        self.shadowImage = UIImage()
        self.barStyle = CustomTheme.barStyle()
    }
}
// MARK: UIKit Extension for CustomTheme
enum Theme: String {
    case blue = "Blue"
    case dark = "Dark"
}

extension UILabel {
    func updateFontColor() {
        self.textColor = CustomTheme.textColor()
    }
}

extension UIDatePicker {
    func changeToWhiteFont() {
        self.setValue(CustomTheme.textColor(), forKey: "textColor")
        self.setValue(false, forKey: "highlightsToday")
    }
}



