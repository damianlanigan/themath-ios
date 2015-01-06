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
            return UIColor.category_blueColor()
        case .Lifestyle:
            return UIColor.category_orangeColor()
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
    
    class func category_blueColor() -> UIColor {
        return UIColor(red:0.141, green:0.537, blue:0.906, alpha:1)
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
}
