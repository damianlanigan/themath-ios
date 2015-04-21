//
//  CategoryView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    
    var selected: Bool = false {
        didSet {
            backgroundColor = selected ? UIColor.whiteColor().colorWithAlphaComponent(0.6) : UIColor.clearColor()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        selected = !selected
    }
    
    func name() -> String {
        return ""
    }
}
