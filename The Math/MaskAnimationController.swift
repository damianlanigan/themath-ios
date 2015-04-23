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
    var toViewController: UIViewController?
    var fromViewController: UIViewController?
    var context: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.35
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        fromViewController = context!.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        toViewController = context!.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = context!.containerView()
        
        if presenting {
            fromViewController!.view.userInteractionEnabled = false
            toViewController!.view.userInteractionEnabled = false
            containerView.addSubview(toViewController!.view)
            containerView.bringSubviewToFront(toViewController!.view)
            toViewController!.view.alpha = 0.0
            UIView.animateWithDuration(0.45, animations: {
                (self.fromViewController! as! MoodViewController).contentView.transform = CGAffineTransformMakeScale(10.5, 10.5)
                }, completion: { (done: Bool) -> Void in
                    UIView.animateWithDuration(0.2, animations: {
                        self.toViewController!.view.alpha = 1.0
                        }, completion: { (done: Bool) -> Void in
                            (self.fromViewController! as! MoodViewController).contentView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            self.toViewController!.view.userInteractionEnabled = true
                            self.context!.completeTransition(true)
                    })
            })
        } else {
            var buttonFrame = CGRectMake(0, 0, 160, 160)
            buttonFrame.origin.x = toViewController!.view.center.x - 80
            buttonFrame.origin.y = toViewController!.view.center.y - 80
            var circleMaskPathFinal  = UIBezierPath(ovalInRect: buttonFrame)
            var extremePoint = CGPoint(x: toViewController!.view.center.x - 0, y: toViewController!.view.center.y - CGRectGetHeight(fromViewController!.view.bounds))
            var radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y))
            var circleMaskPathInitial = UIBezierPath(ovalInRect: CGRectInset(buttonFrame, -radius, -radius))
            
            var maskLayer = CAShapeLayer()
            maskLayer.path = circleMaskPathFinal.CGPath
            fromViewController!.view.layer.mask = maskLayer
            
            var maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
            maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
            maskLayerAnimation.duration = transitionDuration(context!)
            maskLayerAnimation.delegate = self
            maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
            
            let duration = 0.2
            
            if let viewController = fromViewController as? JournalViewController {
                viewController.fadeOutInitial(duration, completion: { () -> Void in
                    let delay = 1.0 * Double(NSEC_PER_SEC)
                    var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    viewController.saved()
                    dispatch_after(time, dispatch_get_main_queue(), {
                        buttonFrame.size = CGSizeMake(70.0, 70.0)
                        buttonFrame.origin.x = self.toViewController!.view.center.x - 35
                        buttonFrame.origin.y = self.toViewController!.view.center.y - 35
                        maskLayer.path = UIBezierPath(ovalInRect: buttonFrame).CGPath
                        maskLayerAnimation.fromValue = circleMaskPathFinal.CGPath
                        maskLayerAnimation.toValue = UIBezierPath(ovalInRect: buttonFrame)
                        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
                        
                        viewController.fadeOutFinal(self.transitionDuration(transitionContext), completion: { () -> Void in
                            self.toViewController!.view.userInteractionEnabled = true
                            self.context!.completeTransition(true)
                        })
                    })
                })
            }
        }
    }

}
