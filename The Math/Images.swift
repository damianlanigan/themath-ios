//
//  Images.swift
//  The Math
//
//  Created by Mike Kavouras on 1/6/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func imageForCategoryType(type: CategoryType) -> UIImage {
        switch type {
        case .Personal:
            return UIImage.categoryAsset("self")
        case .Lifestyle:
            return UIImage.categoryAsset("lifestyle")
        case .Money:
            return UIImage.categoryAsset("money")
        case .Health:
            return UIImage.categoryAsset("health")
        case .Work:
            return UIImage.categoryAsset("work")
        case .Love:
            return UIImage.categoryAsset("love")
        }

    }
    
    class func imageForMood(mood: Mood) -> UIImage {
        switch mood {
        case .Horrible:
            return UIImage.moodAsset("1")
        case .Bad:
            return UIImage.moodAsset("2")
        case .Good:
            return UIImage.moodAsset("3")
        case .Great:
            return UIImage.moodAsset("4")
        }
    }
    
    class func categoryAsset(name: String) -> UIImage {
        return UIImage(named: "categoryIcon_\(name)")!
    }
    
    class func moodAsset(name: String) -> UIImage {
        return UIImage(named: "ratingIcon_\(name)")!
    }

}
