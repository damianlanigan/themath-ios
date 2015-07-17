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
    
}