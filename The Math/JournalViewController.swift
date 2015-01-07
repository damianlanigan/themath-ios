//
//  JournalViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol JournalViewControllerDelegate {
    func didBeginEditingMood()
    func didEndEditingMood()
}

class JournalViewController: UIViewController, CategoryViewDelegate {
    
    @IBOutlet weak var personalView: PersonalView!
    @IBOutlet weak var lifestyleView: LifestyleView!
    @IBOutlet weak var moneyView: MoneyView!
    @IBOutlet weak var healthView: HealthView!
    @IBOutlet weak var workView: WorkView!
    @IBOutlet weak var loveView: LoveView!
    
    @IBOutlet weak var moodDescriptionView: UIView!
    
    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var moodDescriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var delegate: JournalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalView.delegate = self
        lifestyleView.delegate = self
        moneyView.delegate = self
        healthView.delegate = self
        workView.delegate = self
        loveView.delegate = self
    }
    
    
    // MARK: <CategoryViewDelegate>
    
    func moodChangedForCategory(mood: Mood, category: Category) {
        moodImageView.image = UIImage.imageForMood(mood)
        moodDescriptionLabel.text = "Feeling \(mood.rawValue)"
        categoryLabel.text = category.type.rawValue
    }
    
    func didBeginMoodChangeForCategory(category: Category) {
        delegate?.didBeginEditingMood()
        UIView.animateWithDuration(0.2, animations: {
            self.moodDescriptionView.alpha = 1.0
        })
    }
    
    func didEndMoodChangeForCategory(category: Category) {
        delegate?.didEndEditingMood()
        UIView.animateWithDuration(0.2, animations: {
            self.moodDescriptionView.alpha = 0.0
        })
    }
}
