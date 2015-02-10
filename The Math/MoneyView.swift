//
//  👨
//
//  MoneyView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class MoneyView: CategoryView {

    override init(category: Category?) {
        super.init(category: Category(type: .Money))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        category = Category(type: .Money)
        nameLabel.text = "Money"
    }

}
