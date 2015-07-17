//
//  ScaleDistanceView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 6/30/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class ScaleDistanceView: UIView {

    var active = false {
        didSet {
            if active && oldValue == false {
                grow()
            } else if !active && oldValue == true {
                shrink()
            }
        }
    }
    
    private func grow() {
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            self.transform = CGAffineTransformMakeScale(1.18, 1.18)
            }, completion: { (_: Bool) -> Void in
        })
    }
    
    private func shrink() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
            self.transform = CGAffineTransformIdentity
            }, completion: { (_: Bool) -> Void in
        })
    }

}
