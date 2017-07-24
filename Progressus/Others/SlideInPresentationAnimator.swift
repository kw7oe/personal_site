//
//  SlideInPresentationAnimator.swift
//  Progressus
//
//  Created by Choong Kai Wern on 24/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class SlideInPresentationAnimator: NSObject {
    
    let isPresentation: Bool
    
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }
}

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        let key2 = isPresentation ? UITransitionContextViewControllerKey.from :
            UITransitionContextViewControllerKey.to
        
        let controller = transitionContext.viewController(forKey: key)!
        let fvc = transitionContext.viewController(forKey: key2)!
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        } 
        
        let fvcpresentedFrame = transitionContext.finalFrame(for: fvc)
        var fvcdismissedFrame = fvcpresentedFrame
        
        fvcdismissedFrame.origin.x = -transitionContext.containerView.frame.size.width * (2.0 / 5.0)
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        
        dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let fvcinitialFrame = isPresentation ? fvcpresentedFrame : fvcdismissedFrame
        let fvcfinalFrame = isPresentation ? fvcdismissedFrame : fvcpresentedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        fvc.view.frame = fvcinitialFrame
        UIView.animate(withDuration: animationDuration, animations: { 
            controller.view.frame = finalFrame
            fvc.view.frame = fvcfinalFrame
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
}
