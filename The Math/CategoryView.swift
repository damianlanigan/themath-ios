//
//  CategoryView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol CategoryViewDelegate {
    func moodChangedForCategory(mood: Mood, category: Category)
    func didBeginMoodChangeForCategory(category: Category)
    func didEndMoodChangeForCategory(category: Category)
}

class CategoryView: UIView {
    
    var originalY: CGFloat = 0.0
    
    var category: Category
    
    var delegate: CategoryViewDelegate?

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
            delegate?.didBeginMoodChangeForCategory(category)
            originalY = gesture.view!.center.y
            
            UIView.animateWithDuration(0.4, animations: {
                self.nameLabel.alpha = 1.0
            })
        }
        
        if gesture.state == .Changed {
            let x = gesture.view!.center.x
            let y = gesture.translationInView(gesture.view!).y
        
            let distance = y * 0.36 * -1
            
            if distance > 0 {
                if distance >= 40 {
                    delegate?.moodChangedForCategory(.Great, category: category)
                } else if distance >= 0 {
                    delegate?.moodChangedForCategory(.Good, category: category)
                }
            } else {
                if distance <= -40 {
                    delegate?.moodChangedForCategory(.Horrible, category: category)
                } else if distance < 0 {
                    delegate?.moodChangedForCategory(.Bad, category: category)
                }
            }
            
            gesture.view!.center = CGPoint(x: x, y: originalY + (y * 0.36))
        }
        
        if gesture.state == .Ended {
            delegate?.didEndMoodChangeForCategory(category)
            
            UIView.animateWithDuration(0.2, animations: {
                self.sliderView.center = CGPoint(x: self.sliderView.center.x, y: self.originalY)
                self.nameLabel.alpha = 0.5
            })
        }
    }
}
