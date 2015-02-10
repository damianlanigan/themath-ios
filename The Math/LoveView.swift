//
//  👨
//
//  LoveView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class LoveView: CategoryView {

    override init(category: Category?) {
        super.init(category: Category(type: .Love))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        category = Category(type: .Love)
        nameLabel.text = "Love"
    }

}
