//
//  Constant.swift
//  Up
//
//  Created by Choong Kai Wern on 04/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation
import UIKit

enum Theme: String {
    case light = "Light"
    case dark = "Dark"
}

struct CustomTheme {
    
    private struct Colors {
        static var white = UIColor.init(white: 0.98, alpha: 1)
        static var ultraLightGray = UIColor.init(white: 0.95, alpha: 1)
        static var lightGray = UIColor.init(white: 0.90, alpha: 1)
        static var gray = UIColor.init(white: 0.60, alpha: 1)
        static var darkGray = UIColor.init(white: 0.15, alpha: 1)
        
        static var gunmetal = UIColor.init(hexString: "#283440")
        static var charchoal = UIColor.init(hexString: "#344250")
        static var blue = UIColor.init(hexString: "#427dd6")
        static var steelBlue = UIColor.init(hexString: "#0067A5")
        static var moderateBlue = UIColor.init(hexString: "#42a2d6")
        // #42c7d6
        static var moderateCyan = UIColor.init(red: 0.259, green: 0.78, blue: 0.839, alpha: 1)
    }
    
    static let colors: [[UIColor]] = [
        [Colors.blue, Colors.moderateBlue],
        [Colors.steelBlue, Colors.moderateCyan]
    ]
    
    static var color: [UIColor] = colors[Settings.colorIndex]
    
    static func cellBackgroundColor() -> UIColor {
        if Settings.theme == .light {
            return Colors.white
        }
        return Colors.charchoal
    }
    
    static func cellSelectedView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return view
    }
    
    static func backgroundColor() -> UIColor {
        if Settings.theme == .light {
            return Colors.ultraLightGray
        }
        return Colors.gunmetal
    }
    
    static func barStyle() -> UIBarStyle {
        if Settings.theme == .light {
            return UIBarStyle.default
        }
        return UIBarStyle.black
    }
    
    static func textColor() -> UIColor {
        if Settings.theme == .light {
            return Colors.darkGray
        }
        return Colors.lightGray
    }
    
    static func placeholderColor() -> UIColor {
        return Colors.gray
    }
    
    static func primaryColor() -> UIColor {
        if Settings.theme == .light {
            return color[0]
        }
        return color[1]
    }
    
    static func lighterPrimaryColor() -> UIColor {
        return primaryColor().withAlphaComponent(0.5)
    }
}
