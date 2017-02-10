//
//  RadiusButton.swift
//  Countdown
//
//  Created by Choong Kai Wern on 13/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit


@IBDesignable
class RadiusButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 18.0
        self.layer.shadowRadius = 5.0
        self.backgroundColor = Color.primaryColor()
    }

}
