//
//  NSObject.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class MaskAnimationController:  NSObject,
    UIViewControllerAnimatedTransitioning {
    
    var presenting = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        if presenting {
            fromViewController.view.userInteractionEnabled = false
            containerView.addSubview(toViewController.view)
            containerView.bringSubviewToFront(toViewController.view)
            toViewController.view.alpha = 0.0
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                fromViewController.view.transform = CGAffineTransformMakeScale(9.0, 9.0)
                }, completion: { (done: Bool) -> Void in
                    UIView.animateWithDuration(0.2, animations: {
                            toViewController.view.alpha = 1.0
                        }, completion: { (done: Bool) -> Void in
                            fromViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            transitionContext.completeTransition(true)
                    })
            })
        } else {
            toViewController.view.userInteractionEnabled = true
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                fromViewController.view.alpha = 0.0
                }, completion: { (done: Bool) -> Void in
                    transitionContext.completeTransition(true)
            })
        }
    }
}
