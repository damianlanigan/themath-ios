//
//  MoodViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class MoodViewController: UIViewController {

    @IBOutlet weak var moodTrigger: RoundButton!
    
    var radius: CGFloat = 46.0
    var circle = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.category_blueColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        let radius: CGFloat = 46
//        let rect: CGRect = CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius)
//        
//        circle.frame = moodTrigger.frame
//        circle.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CG
//        circle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        circle.path = UIBezierPath(roundedRect:rect, cornerRadius:radius).CGPath
//        circle.position = CGPoint(x: view.center.x - rect.size.width / 2.0, y: view.center.y - rect.size.height / 2.0)
//        circle.fillColor = UIColor.clearColor().CGColor
//        circle.strokeColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
//        circle.lineWidth = 2
//        
//        view.layer.addSublayer(circle)
        
//        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: false)

    }
    
    func update() {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        // Set the initial and the final values
        animation.fromValue = 1.0
        animation.toValue = 3.4
        animation.duration = 1.0
        
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        moodTrigger.layer.addAnimation(animation, forKey: "scale")
    }
}
