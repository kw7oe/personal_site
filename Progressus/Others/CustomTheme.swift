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
        
        // Background Color Combination
        static var gunmetal = UIColor.init(hexString: "#283440")
        static var charchoal = UIColor.init(hexString: "#344250")
        static var lighterCharchoal = UIColor.init(hexString: "#52687e")
               
        // Others
        static var steelBlue = UIColor.init(hexString: "#0067A5")
        static var moderateCyan = UIColor.init(hexString: "#42c7d6")
    }
    
    // MARK: Colors Selection
    static let colors: [[UIColor]] = [
        [UIColor.init(hexString: "#427dd6"), UIColor.init(hexString: "#42a2d6")], // Blue
        [UIColor.init(hexString: "#00897B"), UIColor.init(hexString: "#42d6c0")], // Green
        [UIColor.init(hexString: "#5C6BC0"), UIColor.init(hexString: "#536DFE")], // Indigo
        [UIColor.init(hexString: "#F06292"), UIColor.init(hexString: "#FF4081")], // Pink
        [UIColor.init(hexString: "#D64258"), UIColor.init(hexString: "#EB5160")], // Red
        [UIColor.init(hexString: "#FB8C00"), UIColor.init(hexString: "#FFB300")], // Orange
        [UIColor.init(hexString: "#8D6E63"), UIColor.init(hexString: "#A1887F")], // Brown
        
    ]
    
    static var color: [UIColor] {
        return colors[Settings.colorIndex]
    }
    
    // MARK: TableViewCell Visual Customization
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
    
    // MARK: TableView Visual Customization
    static func seperatorColor() -> UIColor? {
        if Settings.theme == .light {
            return nil
        }
        return Colors.lighterCharchoal
    }
    
    // MARK: UINavigationBar Visual Customization
    static func barStyle() -> UIBarStyle {
        if Settings.theme == .light {
            return UIBarStyle.default
        }
        return UIBarStyle.black
    }
    
    // MARK: ColorButton Visual Customization
    static func borderColor() -> UIColor {
        if Settings.theme == .light {
            return Colors.charchoal
        }
        return Colors.lightGray
    }
    
    // MARK: General Visual Customization
    static func navBarTintColor() -> UIColor {
        return cellBackgroundColor()
    }
    
    static func backgroundColor() -> UIColor {
        if Settings.theme == .light {
            return Colors.ultraLightGray
        }
        return Colors.gunmetal
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
    
    static func defaultTintColor() -> UIColor {
        return UIColor(hexString: "#007AFF")
    }
    
    // MARK: Graph 
    static func graphAxisColor() -> UIColor {
        if Settings.theme == .light {
            return Colors.charchoal
        }
        return Colors.lightGray
    }
    
    static func graphTickAxisColor() -> UIColor {
        if Settings.theme == .light {
            return Colors.lightGray
        }
        return Colors.lighterCharchoal
    }
}
