//
//  👨
//
//  Category.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import Swift

enum CategoryType: String {
    case Undefined = "Undefined"
    case Love = "Love"
    case Money = "Money"
    case Social = "Social"
    case Home = "Home"
    case Work = "Work"
    case Health = "Health"
    case Personal = "Self"
    case Chaotic = "Productivity"
}

enum CategoryIndex: Int {
    case Love, Money, Social, Work, Home, Health, Personal, Chaotic
    
    static let categoryNames = [
        Love : "Love", Money : "Money", Social : "Social",
        Work : "Work", Home: "Home", Health : "Health",
        Personal : "Self", Chaotic : "Chaotic"
    ]
    
    func categoryName() -> String {
        if let name = CategoryIndex.categoryNames[self] {
            return name
        } else {
            return "Category"
        }
    }
}

//struct CategoryConstants {
//    static let allCategoriesTypes: [CategoryType] = [
//        .Personal,
//        .Lifestyle,
//        .Money,
//        .Health,
//        .Work,
//        .Love
//    ]
//}

struct Category {
    
    let color: UIColor
    let name: String
    let type: CategoryType
    
//    init(type: CategoryType) {
//        color = UIColor.colorForCategoryType(type)
//        self.type = type
//        name = type.rawValue
//    }
    
}

enum Mood: String {
    case Horrible = "Horrible"
    case Bad = "Bad"
    case Neutral = ""
    case Good = "Good"
    case Great = "Great"
}
