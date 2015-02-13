//
//  CategoryCoordinator.swift
//  The Math
//
//  Created by Michael Kavouras on 2/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

let CategoriesDidUpdateNotification = "CategoriesDidUpdate"

class CategoryCoordinator: NSObject {
    
    var categories = [Category]()
    
    func updateCategories(types: [CategoryType]) {
        categories = [Category]()
        for type in types {
            categories.append(Category(type: type))
        }
        NSNotificationCenter.defaultCenter().postNotificationName(CategoriesDidUpdateNotification, object: nil)
        Tracker.trackNumberOfCategoriesSelected(categories.count)
    }
   
    class func sharedInstance() -> CategoryCoordinator {
        struct Instance {
            static let singleton = CategoryCoordinator()
        }
        return Instance.singleton
    }
    
}
