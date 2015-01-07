//
//  Category.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

enum CategoryType: String {
    case Personal = "Self"
    case Lifestyle = "Lifestyle"
    case Money = "Money"
    case Health = "Health"
    case Work = "Work"
    case Love = "Love"
}

enum Mood: String {
    case Horrible = "Horrible"
    case Bad = "Bad"
    case Good = "Good"
    case Great = "Great"
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
    
}
