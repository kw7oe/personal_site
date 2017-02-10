//
//  Constant.swift
//  Up
//
//  Created by Choong Kai Wern on 04/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation
import UIKit

struct Color {
    static func backgroundColor() -> UIColor {
        if Settings.theme == .blue {
            return UIColor.init(white: 0.98, alpha: 1)
        }
        return UIColor.init(white: 0.02, alpha: 1)
    }
    
    static func textColor() -> UIColor {
        if Settings.theme == .blue {
            return UIColor.init(white: 0.02, alpha: 1)
        }
        return UIColor.init(white: 0.98, alpha: 1)
    }
    
    static func placeholderColor() -> UIColor {
        return UIColor.init(white: 0.60, alpha: 1)
    }
    
    static func primaryColor() -> UIColor {
        if Settings.theme == .blue {
            return UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 1)
        }
        return UIColor.init(red: 0.839, green: 0.753, blue: 0.259, alpha: 1) // #d69b42
    }
    
    static func lighterPrimaryColor() -> UIColor {
        if Settings.theme == .blue {
            return UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 0.5)
        }
        return UIColor.init(red: 0.839, green: 0.753, blue: 0.259, alpha: 0.5)
    }
}
