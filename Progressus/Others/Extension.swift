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
extension UIViewController {
    var contentViewController: UIViewController {
        if let navController = self as? UINavigationController {
            return navController.visibleViewController ?? navController
        } else {
            return self
        }
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        var string:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if string.hasPrefix("#") {
            string.remove(at: string.startIndex)
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: string).scanHexInt32(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16)
        let g = CGFloat((rgbValue & 0x00FF00) >> 8)
        let b = CGFloat((rgbValue & 0x0000FF) >> 0)
        
        self.init(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


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
    func customize() {
        self.backgroundColor = CustomTheme.cellBackgroundColor()
        self.textLabel?.textColor = CustomTheme.textColor()
        self.detailTextLabel?.textColor = CustomTheme.textColor()
        self.selectedBackgroundView = CustomTheme.cellSelectedView()
    }
}

extension UINavigationBar {
    /**
     Remove Background and Bottom Border of Nagivation Bar
     */
    func none() {
        self.barStyle = CustomTheme.barStyle()
        self.isTranslucent = false
        self.barTintColor = CustomTheme.cellBackgroundColor()
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



