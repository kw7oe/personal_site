//
//  ColorButton.swift
//  Progressus
//
//  Created by Choong Kai Wern on 30/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ColorButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func selected() {
        layer.borderWidth = 2
    }
    
    func unselect() {
        layer.borderWidth = 0
    }
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        backgroundColor = color
        layer.cornerRadius = bounds.width * 0.5
        layer.borderColor = CustomTheme.borderColor().cgColor
    }

}
