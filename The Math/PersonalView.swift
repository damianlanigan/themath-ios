//
//  PersonalView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class PersonalView: CategoryView {
    
    let category: Category

    required init(coder aDecoder: NSCoder) {
        category = Category(type: .Personal)
        super.init(coder: aDecoder)
    }

}
