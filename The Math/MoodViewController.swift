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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.category_blueColor()
        
        let radius: CGFloat = 46
        let rect: CGRect = CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius)
        
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(roundedRect:rect, cornerRadius:radius).CGPath;
        circle.position = CGPoint(x: view.center.x - rect.size.width / 2.0, y: view.center.y - rect.size.height / 2.0)
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        circle.lineWidth = 2
        
        view.layer.addSublayer(circle)
    }
}
