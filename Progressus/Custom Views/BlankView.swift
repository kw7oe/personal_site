//
//  BlankView.swift
//  Progressus
//
//  Created by Choong Kai Wern on 13/03/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class BlankView: UIView {
    

    var label: UILabel = UILabel()
    var detailLabel: UILabel = UILabel()
    
    func updateUI() {
        let boldFont = UIFont.boldSystemFont(ofSize: 24.0)
        label.font = boldFont
        let italicFont = UIFont.italicSystemFont(ofSize: 16.0)
        detailLabel.font = italicFont
        label.textColor = CustomTheme.textColor()
        detailLabel.textColor = CustomTheme.textColor()
    }
    
    
    // MARK: View Life Cycle 
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
        
        let center = CGPoint(x: frame.midX, y: frame.midY)
        let size = label.intrinsicContentSize
        let tempFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        label.frame = tempFrame
        label.center = center
        label.textAlignment = .center
        
        detailLabel.frame = tempFrame
        detailLabel.center = CGPoint(x: center.x, y: center.y + tempFrame.height)
        detailLabel.textAlignment = .center
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, title: String, detail: String?) {
        self.init(frame: frame)
        label.text = title
        detailLabel.text = detail
        addSubview(label)
        addSubview(detailLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

