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
        case .Chaotic:
            return UIColor.category_chaoticColor()
        default:
            return UIColor.whiteColor()
        }
    }
    
    // MARK: Category
    
    
    // MARK: Mood
        
    class func category_loveColor() -> UIColor {
        return UIColor(red: 235/255.0, green: 73/255.0, blue: 135/255.0, alpha: 1.0)
    }
    
    class func category_moneyColor() -> UIColor {
        return UIColor(red: 81/255.0, green: 215/255.0, blue: 85/255.0, alpha: 1.0)
    }
    
    class func category_socialColor() -> UIColor {
        return UIColor(red: 66/255.0, green: 115/255.0, blue: 187/255.0, alpha: 1.0)
    }
    
    class func category_workColor() -> UIColor {
        return UIColor(red: 195/255.0, green: 72/255.0, blue: 217/255.0, alpha: 1.0)
    }

    class func category_homeColor() -> UIColor {
        return UIColor(red: 190/255.0, green: 237/255.0, blue: 59/255.0, alpha: 1.0)
    }
    
    class func category_healthColor() -> UIColor {
        return UIColor(red: 74/255.0, green: 186/255.0, blue: 217/255.0, alpha: 1.0)
    }
    
    class func category_selfColor() -> UIColor {
        return UIColor(red: 252/255.0, green: 162/255.0, blue: 66/255.0, alpha: 1.0)
    }
    
    class func category_chaoticColor() -> UIColor {
        return UIColor(red: 252/255.0, green: 94/255.0, blue: 66/255.0, alpha: 1.0)
    }
    
    // gradient
    
    class func mood_gradientColors() -> [CGColorRef] {
        let colors: [CGColorRef] = [
            
            /* original
            UIColor(red:0.012, green:0.067, blue:0.263, alpha: 1).CGColor,
            UIColor(red:0.082, green:0.227, blue:0.741, alpha: 1).CGColor,
            UIColor(red:0.200, green:0.373, blue:1.000, alpha: 1).CGColor,
            UIColor(red:1.000, green:0.549, blue:0.953, alpha: 1).CGColor
            */
            
            /* v2
            UIColor(red: 102/255.0,green: 102/255.0, blue: 102/255.0, alpha: 1).CGColor,
            UIColor(red: 93/255.0, green: 114/255.0, blue: 114/255.0, alpha: 1).CGColor,
            UIColor(red: 83/255.0, green: 127/255.0, blue: 127/255.0, alpha: 1).CGColor,
            UIColor(red: 75/255.0, green: 143/255.0, blue: 143/255.0, alpha: 1).CGColor,
            UIColor(red: 63/255.0, green: 168/255.0, blue: 168/255.0, alpha: 1).CGColor
            */
            
            /* orange green
            UIColor(red:0.345, green:0.514, blue:0.404, alpha: 1).CGColor,
            UIColor(red:0.561, green:0.600, blue:0.349, alpha: 1).CGColor,
            UIColor(red:0.765, green:0.620, blue:0.318, alpha: 1).CGColor,
            UIColor(red:0.890, green:0.627, blue:0.302, alpha: 1).CGColor,
            UIColor(red:0.980, green:0.718, blue:0.267, alpha: 1).CGColor
            */
            
            UIColor(red:0.149, green:0.180, blue:0.290, alpha: 1).CGColor,
            UIColor(red:0.137, green:0.306, blue:0.416, alpha: 1).CGColor,
            UIColor(red:0.212, green:0.600, blue:0.659, alpha: 1).CGColor,
            UIColor(red:0.259, green:0.843, blue:0.843, alpha: 1).CGColor
            
        ]
        return colors
    }
    
    class func mood_initialColor() -> UIColor {
        return UIColor(red:0.133, green:0.733, blue:0.965, alpha: 1)
    }
    
    class func mood_blueColor() -> UIColor {
        return UIColor(red:0.133, green:0.733, blue:0.965, alpha: 1)
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
