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
    
//    class func colorForCategoryType(type: CategoryType) -> UIColor {
//        switch type {
//        case .Personal:
//            return UIColor.category_orangeColor()
//        case .Lifestyle:
//            return UIColor.category_blueColor()
//        case .Money:
//            return UIColor.category_greenColor()
//        case .Health:
//            return UIColor.category_lightBlueColor()
//        case .Work:
//            return UIColor.category_purpleColor()
//        case .Love:
//            return UIColor.category_pinkColor()
//        }
//    }
    
    // MARK: Category
    
    class func category_blueColor() -> UIColor {
        return UIColor(red:0.188, green:0.439, blue:0.851, alpha: 1)
    }
    
    class func category_lightBlueColor() -> UIColor {
        return UIColor(red:0.290, green:0.729, blue:0.851, alpha: 1)
    }
    
    class func category_orangeColor() -> UIColor {
        return UIColor(red:0.988, green:0.635, blue:0.259, alpha: 1)
    }
    
    class func category_greenColor() -> UIColor {
        return UIColor(red:0.286, green:0.890, blue:0.294, alpha: 1)
    }
    
    class func category_purpleColor() -> UIColor {
        return UIColor(red:0.765, green:0.282, blue:0.851, alpha: 1)
    }
    
    class func category_pinkColor() -> UIColor {
        return UIColor(red:0.922, green:0.286, blue:0.529, alpha: 1)
    }
    
    // MARK: Mood
    
    class func mood_blueColor() -> UIColor {
        return UIColor.category_blueColor()
    }
    
    class func mood_startColor() -> UIColor {
        return UIColor(red:26/255.0, green:119/255.0, blue:160/255.0, alpha: 1)
    }
    
    class func mood_endColor() -> UIColor {
        return UIColor(red:255/255.0, green:231/255.0, blue:87/255.0, alpha: 1)
    }
    
    // MARK: Journal
    
    class func journal_tintColor() -> UIColor {
        return UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
    }
    
    // MARK: Utility
    
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
