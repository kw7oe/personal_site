//
//  CustomNavigationAnimationController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 21/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class CustomNavigationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var direction: CGFloat = -1.0
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let bounds = UIScreen.main.bounds
        let toView = toVC.view!
        
        
        toView.frame = finalFrame.offsetBy(dx: direction * bounds.width, dy: 0)
        containerView.addSubview(toView)
        
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.curveEaseInOut,
            animations: { 
                toView.frame = finalFrame
        }) { finished in
            transitionContext.completeTransition(true)
        }
    }
}
