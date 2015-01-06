//
//  CategoryView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    
    var category: Category
    
    var originalY: CGFloat = 0.0
    
    let maxYOffset: CGFloat = 70.0
    var newY: CGFloat = 0.0

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var sliderView: CategorySliderView!
    
    init(category: Category) {
        self.category = category
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.category = Category(type: .Love)
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.colorForCategoryType(category.type)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setupSlideGesture()
    }
    
    private func setupSlideGesture() {
        let gesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panSliderView:")
        sliderView?.addGestureRecognizer(gesture)
    }
    
    func panSliderView(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .Began {
            originalY = gesture.view!.center.y
            newY = originalY
        }
        
        if gesture.state == .Changed {
            let x = gesture.view!.center.x
            let y = gesture.translationInView(gesture.view!).y
            
            let distanceFromOrigin = fabs(y)
            
            if distanceFromOrigin >= 1 {
                println(maxYOffset / distanceFromOrigin)
            }
            
            newY = originalY + y
            gesture.view!.center = CGPoint(x: x, y: newY)

        }
    }
}
