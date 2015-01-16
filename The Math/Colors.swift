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
        case .Personal:
            return UIColor.category_orangeColor()
        case .Lifestyle:
            return UIColor.category_blueColor()
        case .Money:
            return UIColor.category_greenColor()
        case .Health:
            return UIColor.category_lightBlueColor()
        case .Work:
            return UIColor.category_purpleColor()
        case .Love:
            return UIColor.category_pinkColor()
        }
    }
    
    // MARK: Category
    
    class func category_blueColor() -> UIColor {
        return UIColor(red: 0.117, green:0.478, blue:0.992, alpha:1)
    }
    
    class func category_lightBlueColor() -> UIColor {
        return UIColor(red:0.000, green:0.784, blue:0.969, alpha:1)
    }
    
    class func category_orangeColor() -> UIColor {
        return UIColor(red:0.973, green:0.529, blue:0.000, alpha:1)
    }
    
    class func category_greenColor() -> UIColor {
        return UIColor(red:0.000, green:0.918, blue:0.518, alpha:1)
    }
    
    class func category_purpleColor() -> UIColor {
        return UIColor(red:0.729, green:0.000, blue:0.843, alpha:1)
    }
    
    class func category_pinkColor() -> UIColor {
        return UIColor(red:1.000, green:0.000, blue:0.510, alpha:1)
    }
    
    // MARK: Mood
    
    class func mood_blueColor() -> UIColor {
        return UIColor.category_blueColor()
    }
    
    class func mood_startColor() -> UIColor {
        return UIColor(red:0.036, green:0.144, blue:0.263, alpha:1)
    }
    
    class func mood_endColor() -> UIColor {
        return UIColor(red:0.93, green:0.862, blue:0.12, alpha:1)
    }
    
    class func particle_startColor() -> UIColor {
        return UIColor(red:0.082, green:0.376, blue:0.725, alpha: 1)
    }
    
    class func particle_endColor() -> UIColor {
        return UIColor(red:1.000, green:0.965, blue:0.298, alpha: 1)
    }
}
