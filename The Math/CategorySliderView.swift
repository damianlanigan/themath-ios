//
//  CategorySliderView.swift
//  The Math
//
//  Created by Mike Kavouras on 1/6/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class CategorySliderView: RoundView {
    
    @IBOutlet var sliderCategoryIconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 7
    }

}
