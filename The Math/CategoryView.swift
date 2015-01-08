//
//  CategoryView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol CategoryViewDelegate {
    func didChangeMoodForCategory(mood: Mood, category: Category)
    func didBeginMoodChangeForCategory(category: Category)
    func didEndMoodChangeForCategory(mood: Mood, category: Category)
    func didCancelMoodChange()
}

class CategoryView: UIView, CategorySliderViewDelegate {
    
    var originalY: CGFloat = 0.0
    
    var category: Category
    var delegate: CategoryViewDelegate?
    
    var levelImageView: UIImageView?
    
    var currentMood: Mood = .Neutral
    
    var didSlide = false

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
        sliderView.sliderCategoryIconView.image = UIImage.imageForCategoryType(category.type)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sliderView.delegate = self
        setupSlideGesture()
    }

    private func setupSlideGesture() {
        let gesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panSliderView:")
        sliderView.addGestureRecognizer(gesture)
    }
    
    private func cleanup() {
        didSlide = false
        if let view = levelImageView {
            UIView.animateWithDuration(0.2, animations: {
                view.alpha = 0.0
                }, completion: { (done: Bool) -> Void in
                    view.removeFromSuperview()
            })
        }
    }
    
    func panSliderView(gesture: UIPanGestureRecognizer) {
        
        let maxDistance = 100.0
        
        if gesture.state == .Began {
            originalY = gesture.view!.center.y
            
            UIView.animateWithDuration(0.4, animations: {
                self.nameLabel.alpha = 1.0
            })
            
            didSlide = true
        }
        
        if gesture.state == .Changed {
            let x = gesture.view!.center.x
            let y = gesture.translationInView(gesture.view!).y
        
            let distance = y * 0.5 * -1

            if distance > 30 {
                if distance >= 78 {
                    currentMood = .Great
                } else if distance >= 38 {
                    currentMood = .Good
                }
            } else if distance < -30 {
                if distance <= -78 {
                    currentMood = .Horrible
                } else if distance < 38 {
                    currentMood = .Bad
                }
            } else {
                currentMood = .Neutral
            }
            delegate?.didChangeMoodForCategory(currentMood, category: category)

            
            gesture.view!.center = CGPoint(x: x, y: originalY + (y * 0.5))
        }
        
        if gesture.state == .Ended {
            if currentMood == .Neutral {
                delegate?.didCancelMoodChange()
            } else {
                delegate?.didEndMoodChangeForCategory(currentMood, category: category)
            }
            
            UIView.animateWithDuration(0.6, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .CurveEaseOut, animations: {
                self.sliderView.center = CGPoint(x: self.sliderView.center.x, y: self.originalY)
                self.nameLabel.alpha = 0.5
                }, completion: { (done: Bool) -> Void in
                    return()
            })
            
            cleanup()
        }
    }
    
    
    // MARK: <CategorySliderViewDelegate>
    
    func sliderTouchesBegan() {
        delegate?.didBeginMoodChangeForCategory(category)

        currentMood = .Neutral
        delegate?.didChangeMoodForCategory(currentMood, category: category)
        
        let levels = UIImage(named: "ratingLevels")
        levelImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 160))
        levelImageView!.center = sliderView.center
        levelImageView!.image = levels
        levelImageView!.alpha = 0.0
        
        insertSubview(levelImageView!, belowSubview: sliderView)
        
        UIView.animateWithDuration(0.4, animations: {
            self.levelImageView!.alpha = 1.0
        })
    }
    
    func sliderTouchesEnded() {
        if !didSlide {
            delegate?.didCancelMoodChange()
            cleanup()
        }
    }
}
