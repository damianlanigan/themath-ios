//
//  👨
//
//  CategoryView.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol CategoryViewDelegate: class {
    func didChangeMoodForCategory(mood: Mood, category: Category)
    func didBeginMoodChangeForCategory(category: Category)
    func didEndMoodChangeForCategory(mood: Mood, category: Category)
    func didCancelMoodChange()
}

class CategoryView: UIView, CategorySliderViewDelegate {
    
    private lazy var kSlideRateDistance: CGFloat = {
       return 39.0
    }()
    private lazy var kNeutralThreshold: CGFloat = {
       return 12.0
    }()
    private lazy var kBadThreshold: CGFloat = {
        return self.kSlideRateDistance
    }()
    private lazy var kHorribleThreshold: CGFloat = {
        return self.kSlideRateDistance * 2.0
    }()
    private lazy var kGoodThreshold: CGFloat = {
        return self.kSlideRateDistance * -1.0
    }()
    private lazy var kGreatThreshold: CGFloat = {
        return self.kSlideRateDistance * -2.0
    }()
    
    var category: Category {
        didSet {
            didSetCategory()
        }
    }
    
    weak var delegate: CategoryViewDelegate?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = category.name
        sliderView.delegate = self
        setupSlideGesture()
    }

    private func setupSlideGesture() {
        let gesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panSliderView:")
        sliderView.addGestureRecognizer(gesture)
    }
    
    func didSetCategory() {
        backgroundColor = UIColor.colorForCategoryType(category.type)
        sliderView.sliderCategoryIconView.image = UIImage.imageForCategoryType(category.type)
        nameLabel.text = category.name
    }
    
    func panSliderView(gesture: UIPanGestureRecognizer) {
        
        let maxDistance = 100.0
        
        if gesture.state == .Began {
            
            UIView.animateWithDuration(0.4, animations: {
                self.nameLabel.alpha = 1.0
            })
            
            didSlide = true
        }
        
        if gesture.state == .Changed {
            let x = gesture.view!.center.x
            var y = gesture.translationInView(gesture.view!).y
            y = y < 0 ? max(y, -78) : min(y, 78)
            let distance = y

            currentMood = moodForDistance(distance)
            gesture.view!.center = CGPoint(x: x, y: center.y + distance)
            
            delegate?.didChangeMoodForCategory(currentMood, category: category)
        }
        
        if gesture.state == .Ended {
            if currentMood == .Neutral {
                delegate?.didCancelMoodChange()
            } else {
                delegate?.didEndMoodChangeForCategory(currentMood, category: category)
            }

            UIView.animateWithDuration(0.6, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .CurveEaseOut, animations: {
                self.sliderView.center = CGPoint(x: self.sliderView.center.x, y: self.center.y)
                self.nameLabel.alpha = 0.5
                if let view = self.levelImageView {
                    view.alpha = 0.0
                }
                }, completion: { (done: Bool) -> Void in
                    return()
            })
            
            didSlide = false
        }
    }
    
    private func moodForDistance(distance: CGFloat) -> Mood {
        var mood = currentMood
        if abs(distance) > kNeutralThreshold {
            if distance >= kHorribleThreshold {
                mood = .Horrible
            } else if distance >= kBadThreshold {
                mood = .Bad
            } else if distance <= kGreatThreshold {
                mood = .Great
            } else if distance < kGoodThreshold {
                mood = .Good
            }
        } else {
            mood = .Neutral
        }
        
        return mood
    }
    
    
    // MARK: <CategorySliderViewDelegate>
    
    func sliderTouchesBegan() {
        delegate?.didBeginMoodChangeForCategory(category)

        currentMood = .Neutral
        delegate?.didChangeMoodForCategory(currentMood, category: category)
        
        if levelImageView == nil {
            let levels = UIImage(named: "ratingLevels")
            levelImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 172))
            levelImageView!.image = levels
            levelImageView!.alpha = 0.0
            
            insertSubview(levelImageView!, belowSubview: sliderView)
        }
        
        levelImageView!.center = sliderView.center
        UIView.animateWithDuration(0.4, animations: {
            self.levelImageView!.alpha = 0.5
        })
    }
    
    func sliderTouchesEnded() {
        if !didSlide {
            delegate?.didCancelMoodChange()
            if let view = self.levelImageView {
                UIView.animateWithDuration(0.2, animations: {
                    view.alpha = 0.0
                })
            }
        }
    }

}
