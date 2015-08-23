//
//  Colors_Mood.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 7/17/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func mood_initialColor() -> UIColor {
        return UIColor(red:0.133, green:0.733, blue:0.965, alpha: 1)
    }
    
    // top color
    class func mood_endColor() -> UIColor {
        return UIColor(red:1.000, green:0.678, blue:0.992, alpha: 1)
    }
    
    // middle color / background
    class func mood_blueColor() -> UIColor {
        return UIColor(red:0.333, green:0.322, blue:0.843, alpha: 1)
    }
    
    // bottom color
    class func mood_startColor() -> UIColor {
        return UIColor(red:0.165, green:0.141, blue:0.192, alpha: 1)
    }
    
    // probably shouldnt be here
    class func mood_latestMoodColor() -> UIColor {
        if let entry = Account.currentUser().latestEntry {
            return entry.color
        }
        return UIColor.mood_blueColor()
    }
    
}
