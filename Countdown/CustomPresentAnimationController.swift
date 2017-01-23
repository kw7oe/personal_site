//
//  CustomPresentAnimationController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 21/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let bounds = UIScreen.main.bounds
    
        containerView.addSubview(toVC.view)
        toVC.view.frame = finalFrame.offsetBy(dx: 0, dy: bounds.height)
        
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: { 
                        toVC.view.frame = finalFrame
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }

}
