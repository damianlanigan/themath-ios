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
    
    var categories: [Category] = [Category]()
    
    func updateCategories(types: [CategoryType]) {
//        categories = types.map({ Category(type: $0) })
//        Tracker.track("categories", action: "selected", label: "\(categories.count)")
//        NSNotificationCenter.defaultCenter().postNotificationName(CategoriesDidUpdateNotification, object: nil)
    }
   
    class func sharedInstance() -> CategoryCoordinator {
        struct Instance {
            static let singleton = CategoryCoordinator()
        }
        return Instance.singleton
    }
    
}
