//
//  BorderedView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/14/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class BorderedView: UIView {
    
    var laid = false

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !laid {
            laid = true
            let color = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).CGColor
            let height = 1.0 / UIScreen.mainScreen().scale
            
            let topLayer = CALayer()
            topLayer.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, height)
            topLayer.backgroundColor = color
            
            let bottomLayer = CALayer()
            bottomLayer.frame = CGRectMake(0, frame.size.height - height, UIScreen.mainScreen().bounds.width, height)
            bottomLayer.backgroundColor = color
            
            layer.addSublayer(topLayer)
            layer.addSublayer(bottomLayer)
        }
    }

}
