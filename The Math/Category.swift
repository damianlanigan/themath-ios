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
    case Personal = "Self"
    case Lifestyle = "Lifestyle"
    case Money = "Money"
    case Health = "Health"
    case Work = "Work"
    case Love = "Love"
}

enum CategoryIndex: Int {
    case Personal, Lifestyle, Money, Health, Work, Love
    
    static let categoryNames = [
        Personal : "Self", Lifestyle : "Lifestyle", Money : "Money",
        Health : "Health", Work : "Work", Love : "Love"
    ]
    
    func categoryName() -> String {
        if let name = CategoryIndex.categoryNames[self] {
            return name
        } else {
            return "Category"
        }
    }
    
    func categoryImage() -> UIImage {
        let categoryType = CategoryType(rawValue: self.categoryName())
        return UIImage.imageForCategoryType(categoryType!)
    }
    
    func categoryColor() -> UIColor {
        let categoryType = CategoryType(rawValue: self.categoryName())
        return UIColor.colorForCategoryType(categoryType!)
    }
    
    func categoryType() -> CategoryType {
        return CategoryType(rawValue: self.categoryName())!
    }
}

enum Mood: String {
    case Horrible = "Horrible"
    case Bad = "Bad"
    case Neutral = ""
    case Good = "Good"
    case Great = "Great"
}

struct CategoryConstants {
    static let allCategoriesTypes: [CategoryType] = [
        .Personal,
        .Lifestyle,
        .Money,
        .Health,
        .Work,
        .Love
    ]
}

struct Category {
    
    let color: UIColor
    let name: String
    let type: CategoryType
    
    init(type: CategoryType) {
        color = UIColor.colorForCategoryType(type)
        self.type = type
        name = type.rawValue
    }
    
}
