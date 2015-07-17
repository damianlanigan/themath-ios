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
    
    // MARK: Category
    
    class func colorForCategoryType(type: CategoryType) -> UIColor {
        switch type {
        case .Love:
            return UIColor.category_loveColor()
        case .Money:
            return UIColor.category_moneyColor()
        case .Social:
            return UIColor.category_socialColor()
        case .Work:
            return UIColor.category_workColor()
        case .Home:
            return UIColor.category_homeColor()
        case .Health:
            return UIColor.category_healthColor()
        case .Personal:
            return UIColor.category_selfColor()
        case .Productivity:
            return UIColor.category_productivityColor()
        default:
            return UIColor.whiteColor()
        }
    }
    
    // MARK: Onboarding
    
    class func onboardingBackgroundColor() -> UIColor {
        return UIColor(red:0.949, green:0.980, blue:0.988, alpha: 1)
    }
    
    // MARK: Mood
        
    class func category_loveColor() -> UIColor {
        return UIColor(red:0.961, green:0.165, blue:0.498, alpha: 1)
    }
    
    class func category_moneyColor() -> UIColor {
        return UIColor(red:0.310, green:0.945, blue:0.667, alpha: 1)
    }
    
    class func category_socialColor() -> UIColor {
        return UIColor(red:1.000, green:0.647, blue:0.161, alpha: 1)
    }
    
    class func category_workColor() -> UIColor {
        return UIColor(red:0.329, green:0.424, blue:1.000, alpha: 1)
    }

    class func category_homeColor() -> UIColor {
        return UIColor(red:1.000, green:0.800, blue:0.161, alpha: 1)
    }
    
    class func category_healthColor() -> UIColor {
        return UIColor(red:0.055, green:0.922, blue:1.000, alpha: 1)
    }
    
    class func category_selfColor() -> UIColor {
        return UIColor(red:0.941, green:0.286, blue:0.906, alpha: 1)
    }
    
    class func category_productivityColor() -> UIColor {
        return UIColor(red:0.639, green:0.929, blue:0.427, alpha: 1)
    }
    
    // gradient
    
    class func mood_gradientColors() -> [CGColorRef] {
        let colors: [CGColorRef] = [
            UIColor(red:36/255.0, green:43/255.0, blue:67/255.0, alpha: 1).CGColor,
            UIColor(red:0.137, green:0.306, blue:0.416, alpha: 1).CGColor,
            UIColor(red:0.212, green:0.600, blue:0.659, alpha: 1).CGColor,
            UIColor(red:80/255.0, green:255/255.0, blue:247/255.0, alpha: 1).CGColor
        ]
        return colors
    }
    
    class func mood_initialColor() -> UIColor {
        return UIColor(red:0.133, green:0.733, blue:0.965, alpha: 1)
    }
    
    class func mood_blueColor() -> UIColor {
        return UIColor(red:59/255.0, green:194/255.0, blue:247/255.0, alpha: 1)
    }
    
    class func mood_startColor() -> UIColor {
        let colors = UIColor.mood_gradientColors()
        return UIColor(CGColor: colors[0])!
    }
    
    class func mood_endColor() -> UIColor {
        let colors = UIColor.mood_gradientColors()
        return UIColor(CGColor: colors[colors.count - 1])!
    }
    
    // MARK: Journal
    
    class func journal_tintColor() -> UIColor {
        return UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
    }
    
    // MARK: Utility
    
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
