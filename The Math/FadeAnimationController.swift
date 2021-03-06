//
//  FadeAnimationController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class FadeAnimationController: NSObject,
    UIViewControllerAnimatedTransitioning {
    
    var presenting = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return presenting ? 0.35 : 0.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let context = transitionContext
        let fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        if presenting {
            context.containerView()!.addSubview(toViewController.view)
            toViewController.view.alpha = 0.0
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toViewController.view.alpha = 1.0
                }, completion: { (done: Bool) -> Void in
                    context.completeTransition(done)
            })
        } else {
            fromViewController.view.alpha = 0.0
            toViewController.view.alpha = 1.0
            context.completeTransition(true)
        }
    }
   
}
