//
//  MoodView.swift
//  The Math
//
//  Created by Mike Kavouras on 1/9/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol MoodViewDelegate {
    func moodViewTouchesBegan()
    func moodViewTouchesEnded()
}

class MoodView: UIView {
    
    var delegate: MoodViewDelegate?
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        delegate?.moodViewTouchesBegan()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        delegate?.moodViewTouchesEnded() 
    }
}
