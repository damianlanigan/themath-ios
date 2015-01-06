//
//  PersonalView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class PersonalView: CategoryView {
    
    init() {
        super.init(category: Category(type: .Personal))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        category = Category(type: .Personal)
        nameLabel.text = "Self"
    }

}
