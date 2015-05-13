//
//  AnimatingCircleView.swift
//  HEH
//
//  Created by Jay Schaul on 5/11/15.
//  Copyright (c) 2015 Jay Schaul. All rights reserved.
//

import UIKit

class AnimatingCircleView: UIView {
    
    let MinCircleRadius: UInt32 = 12
    let MaxCircleRadius: UInt32 = 22

    var radius: CGFloat {
        return CGFloat((arc4random() % (MaxCircleRadius - MinCircleRadius)) + MinCircleRadius)
    }
    
    var frameRect: CGRect {
        let r = radius
        return CGRectMake(0.0, 0.0, r * 2.0, r * 2.0)
    }
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.purpleColor()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            let randX = CGFloat(arc4random() % UInt32(superview.frame.size.width))
            let randY = CGFloat(arc4random() % UInt32(superview.frame.size.height))
            frame = frameRect
            frame.origin.x = randX
            frame.origin.y = randY
            layer.cornerRadius = frame.size.width / 2.0
            
            addMotion()
        }
    }
    
    private func addMotion() {
        
        let offset = frame.size.width
        
        let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = -offset
        xAxis.maximumRelativeValue = offset
        
        let yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = -offset
        yAxis.maximumRelativeValue = offset
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xAxis, yAxis]
        
        addMotionEffect(group)
    }
}
