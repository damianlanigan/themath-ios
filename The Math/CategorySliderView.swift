//
//  👨
//
//  CategorySliderView.swift
//  The Math
//
//  Created by Mike Kavouras on 1/6/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol CategorySliderViewDelegate {
    func sliderTouchesBegan()
    func sliderTouchesEnded()
}

class CategorySliderView: RoundView {
    
    @IBOutlet var sliderCategoryIconView: UIImageView!
    
    var delegate: CategorySliderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 7
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        delegate?.sliderTouchesBegan()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        delegate?.sliderTouchesEnded()
    }

}
