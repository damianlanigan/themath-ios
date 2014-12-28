//
//  CategoryView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    
    let category: Category
    
    init(category: Category) {
        self.category = category
        super.init()
        backgroundColor = UIColor.colorForCategoryType(category.type)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.category = Category(type: .Love)
        super.init(coder: aDecoder)
    }

}
