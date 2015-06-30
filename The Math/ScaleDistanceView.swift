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
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
            self.transform = CGAffineTransformMakeScale(1.15, 1.15)
            }, completion: { (_: Bool) -> Void in
        })
    }
    
    private func shrink() {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformIdentity
        })
    }

}
