//
//  Colors.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func onboardingBackgroundColor() -> UIColor {
        return UIColor(red:0.949, green:0.980, blue:0.988, alpha: 1)
    }
    
    class func journal_tintColor() -> UIColor {
        return UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
    }
    
    
    class func moodColorAtPercentage(percentage: CGFloat) -> UIColor {
        return UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: percentage)
    }
    
    class func colorAtPercentage(color1: UIColor, color2: UIColor, perc: CGFloat) -> UIColor {
        
        var red1: CGFloat = 0.0
        var red2: CGFloat = 0.0
        var green1: CGFloat = 0.0
        var green2: CGFloat = 0.0
        var blue1: CGFloat = 0.0
        var blue2: CGFloat = 0.0
        
        let firstComp = CGColorGetComponents(color1.CGColor)
        let secondComp = CGColorGetComponents(color2.CGColor)
        
        if CGColorGetNumberOfComponents(color1.CGColor) == 2 {
            red1 = firstComp[0]
            green1 = firstComp[0]
            blue1 = firstComp[0]
        } else {
            red1 = firstComp[0]
            green1 = firstComp[1]
            blue1 = firstComp[2]
        }
        
        if CGColorGetNumberOfComponents(color2.CGColor) == 2 {
            red2 = secondComp[0]
            green2 = secondComp[0]
            blue2 = secondComp[0]
        } else {
            red2 = secondComp[0]
            green2 = secondComp[1]
            blue2 = secondComp[2]
        }
        
        let newRed = numbers(red1, num2: red2, perc: perc)
        let newGreen = numbers(green1, num2: green2, perc: perc)
        let newBlue = numbers(blue1, num2: blue2, perc: perc)
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    class private func numbers(num: CGFloat, num2: CGFloat, perc: CGFloat) -> CGFloat {
        // 1, 0, 0.5
        let floor = min(num, num2) // 0
        let ceil = max(num, num2) // 1
        let val = (ceil - floor) * perc // 0.5
        return num > num2 ? ceil - val : floor + val
    }

}
