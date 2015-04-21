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
        return 0.35
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        if presenting {
            fromViewController.view.userInteractionEnabled = false
            toViewController.view.userInteractionEnabled = false
            containerView.addSubview(toViewController.view)
            containerView.bringSubviewToFront(toViewController.view)
            toViewController.view.alpha = 0.0
            UIView.animateWithDuration(0.45, animations: {
                fromViewController.view.transform = CGAffineTransformMakeScale(10.5, 10.5)
                }, completion: { (done: Bool) -> Void in
                    UIView.animateWithDuration(0.2, animations: {
                            toViewController.view.alpha = 1.0
                        }, completion: { (done: Bool) -> Void in
                            fromViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            toViewController.view.userInteractionEnabled = true
                            transitionContext.completeTransition(true)
                    })
            })
        } else {
            
            var buttonFrame = CGRectMake(0, 0, 50, 50)
            buttonFrame.origin.x = toViewController.view.center.x - 25
            buttonFrame.origin.y = toViewController.view.center.y - 25
            var circleMaskPathFinal  = UIBezierPath(ovalInRect: buttonFrame)
            var extremePoint = CGPoint(x: toViewController.view.center.x - 0, y: toViewController.view.center.y - CGRectGetHeight(fromViewController.view.bounds))
            var radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
            var circleMaskPathInitial = UIBezierPath(ovalInRect: CGRectInset(buttonFrame, -radius, -radius))
            
            //5
            var maskLayer = CAShapeLayer()
            maskLayer.path = circleMaskPathFinal.CGPath
            fromViewController.view.layer.mask = maskLayer
            
            //6
            var maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
            maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
            maskLayerAnimation.duration = transitionDuration(transitionContext)
            maskLayerAnimation.delegate = self
            maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
            
            let duration = transitionDuration(transitionContext)
            
            (fromViewController as! JournalViewController).fadeOut(duration, completion: { () -> Void in
                toViewController.view.userInteractionEnabled = true
                transitionContext.completeTransition(true)
            })
        }
    }

}
