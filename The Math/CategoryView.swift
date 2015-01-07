//
//  CategoryView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    
    var originalY: CGFloat = 0.0
    
    var category: Category

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
        sliderView.addGestureRecognizer(gesture)
    }
    
    func panSliderView(gesture: UIPanGestureRecognizer) {
        
        let maxDistance = 100.0
        
        if gesture.state == .Began {
            originalY = gesture.view!.center.y
        }
        
        if gesture.state == .Changed {
            let x = gesture.view!.center.x
            let y = gesture.translationInView(gesture.view!).y
        
            let distance = y * 0.36 * -1
            
            if distance > 0 {
                if distance >= 40 {
                    println("great")
                } else if distance >= 0 {
                    println("good")
                }
            } else {
                if distance <= -40 {
                    println("horrible")
                } else if distance < 0 {
                    println("bad")
                }
            }
            
            gesture.view!.center = CGPoint(x: x, y: originalY + (y * 0.36))
        }
    }
}
