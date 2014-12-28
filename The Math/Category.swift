//
//  Category.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

enum CategoryType {
    case Personal
    case Lifestyle
    case Money
    case Health
    case Work
    case Love
}

struct Category {
    
    let color: UIColor

    let name: String
    
    let type: CategoryType
    
    init(type: CategoryType) {
        color = UIColor.colorForCategoryType(type)
        self.type = type
        name = ""
    }
    
    func nameForType(type: CategoryType) -> String {
        return ""
    }
    
    func colorForType(type: CategoryType) -> UIColor {
        return UIColor.whiteColor()
    }
    
}
