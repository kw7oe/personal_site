//
//  Extension.swift
//  Progressus
//
//  Created by Choong Kai Wern on 11/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation
import UIKit


// MARK: General Extension
extension Array {
    
    mutating func prepend(element: Element) {
        self.insert(element, at: 0)
    }
    
}
extension Int {
    
    static func random(upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
    
}
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

// MARK: TableViewCell Extension
extension UITableViewCell {
    func enable(on status: Bool) {
        self.isUserInteractionEnabled = status
        for view in self.contentView.subviews {
            view.alpha = status ? 1 : 0.4
        }
    }
    
    func addGrayDetail(text: String) {
        self.detailTextLabel?.text = text
        self.detailTextLabel?.textColor = UIColor.gray
    }
    
    // Dark Theme
    func black() {
        self.backgroundColor = CustomTheme.backgroundColor()
        self.textLabel?.textColor = CustomTheme.textColor()
        self.detailTextLabel?.textColor = CustomTheme.textColor()
    }
}

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

extension UISwitch {
    func customizeColor() {
        self.onTintColor = CustomTheme.primaryColor()
    }
}



