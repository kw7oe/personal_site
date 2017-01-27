//
//  ProgressBarView.swift
//  Countdown
//
//  Created by Choong Kai Wern on 27/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    
    var progressWidth: CGFloat = 0
    private var outerBar: UIView = UIView()
    private var innerBar: UIView = UIView()
    
    
    init(frame: CGRect, with percentage: CGFloat) {
        super.init(frame: frame)
        
        // SubView
        let newFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        outerBar = UIView(frame: newFrame)
        outerBar.backgroundColor = UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 0.5)
        outerBar.layer.cornerRadius = 10
        innerBar = UIView(frame: newFrame)
        innerBar.backgroundColor = UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 1)
        innerBar.layer.cornerRadius = 10        
        progressWidth = percentage * innerBar.frame.width
        innerBar.frame.size.width = 0
        if progressWidth > outerBar.frame.width {
            progressWidth = outerBar.frame.width
        }
        addSubview(outerBar)
        addSubview(innerBar)
    }
    
    func setProgressBarWidth() {
        innerBar.frame.size.width = progressWidth
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
