//
//  SlideInPresentationManager.swift
//  Progressus
//
//  Created by Choong Kai Wern on 24/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class SlideInPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SlideInPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
