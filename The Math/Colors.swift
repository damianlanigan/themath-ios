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
    
    // MARK: Utility
    
    class func colorAtPercentage(color1: UIColor, color2: UIColor, perc: CGFloat) -> UIColor {

        let firstComp = CGColorGetComponents(color1.CGColor)
        let secondComp = CGColorGetComponents(color2.CGColor)
        
        let red1 = firstComp[0]
        let red2 = secondComp[0]
        let newRed = numbers(red1, num2: red2, perc: perc)
        
        let green1 = firstComp[1]
        let green2 = secondComp[1]
        let newGreen = numbers(green1, num2: green2, perc: perc)
        
        let blue1 = firstComp[2]
        let blue2 = secondComp[2]
        let newBlue = numbers(blue1, num2: blue2, perc: perc)
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    class private func numbers(num: CGFloat, num2: CGFloat, perc: CGFloat) -> CGFloat {
        let floor = min(num, num2)
        let ceil = max(num, num2)
        let val = (ceil - floor) * perc
        return num > num2 ? ceil - val : floor + val
    }

}
