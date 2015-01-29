//
//  👨
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

class JournalViewController: UIViewController, CategoryViewDelegate, JournalAddDetailsViewControllerDelegate {
    
    @IBOutlet weak var personalView: PersonalView!
    @IBOutlet weak var lifestyleView: LifestyleView!
    @IBOutlet weak var moneyView: MoneyView!
    @IBOutlet weak var healthView: HealthView!
    @IBOutlet weak var workView: WorkView!
    @IBOutlet weak var loveView: LoveView!
    
    @IBOutlet weak var moodDescriptionView: UIView!
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var moodDescriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var youreFeelingLabel: UILabel!
    @IBOutlet weak var additionalFeelingTextLabel: UILabel!
    
    @IBOutlet weak var commentViewTopConstraint: NSLayoutConstraint!
    
    lazy var toolTip: AMPopTip = {
        var tip = AMPopTip()
        tip.shouldDismissOnTap = true
        tip.edgeMargin = 10.0
        tip.offset = 12
        tip.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        tip.textAlignment = .Center
        tip.popoverColor = UIColor(red: 228/255.0, green: 238/255.0, blue: 251/255.0, alpha: 1.0)
        return tip
    }()
    
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AMPopTip.appearance().textColor = UIColor.blackColor()
        AMPopTip.appearance().textAlignment = .Center
        let title = NSMutableAttributedString(string: "Pull up or down on any of these")
        
        let range = NSMakeRange(0, countElements(title.string))
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-DemiBold", size: 16)!, range: range)
        
        let message = NSAttributedString(string: "\nIt’ll begin to show you how you stand over time in these categories.", attributes: [
            NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 16)!
            ])
        
        title.appendAttributedString(message)
        
        var fromFrame = CGRectZero
        fromFrame.origin.x = view.center.x
        fromFrame.origin.y = view.center.y + 10
        
        toolTip.showAttributedText(title, direction: .Up, maxWidth: 260, inView: view, fromFrame: fromFrame)
    }
    
    @IBAction func overlayButtonTapped(sender: AnyObject) {
        hideOpportityToAddDetails()
    }
    
    @IBAction func addCommentButtonTapped(sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: JournalAddDetailsViewController = storyboard.instantiateViewControllerWithIdentifier("JournalAddDetailsViewController") as JournalAddDetailsViewController
        viewController.delegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }

    private func presentOpportunityToAddDetails() {
        commentViewTopConstraint.constant = 20
        UIView.animateWithDuration(0.8, delay: 0.2, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 1.0
            
            }) { (done: Bool) -> Void in
                
                UIView.animateWithDuration(0.2, animations: {
                    self.moodDescriptionView.alpha = 0.0
                })
        }
    }
    
    private func hideOpportityToAddDetails() {
        commentViewTopConstraint.constant = -181
        UIView.animateWithDuration(0.4, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 0.0
            
            }) { (done: Bool) -> Void in
                return()
        }

        var timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("cleanup"), userInfo: nil, repeats: false)
    }
    
    func cleanup() {
        delegate?.didEndEditingMood()
    }
    
    
    // MARK: <JournalAddDetailsViewControllerDelegate>
    
    func didSaveJournalDetails() {
        dismissViewControllerAnimated(true, completion: {
            self.hideOpportityToAddDetails()
        })
    }
    
    
    // MARK: <CategoryViewDelegate>
    
    func didChangeMoodForCategory(mood: Mood, category: Category) {
        moodImageView.image = UIImage.imageForMood(mood)
        if mood == .Neutral {
            moodDescriptionLabel.text = ""
        } else {
            moodDescriptionLabel.text = "Feeling \(mood.rawValue)"
        }
        categoryLabel.text = category.type.rawValue
    }
    
    func didBeginMoodChangeForCategory(category: Category) {
        toolTip.hide()
        delegate?.didBeginEditingMood()
        UIView.animateWithDuration(0.2, animations: {
            self.moodDescriptionView.alpha = 1.0
        })
    }
    
    func didEndMoodChangeForCategory(mood: Mood, category: Category) {
        youreFeelingLabel.text = "Feeling \(mood.rawValue) in \(category.type.rawValue)"
        additionalFeelingTextLabel.text = "A little bit of encouraging copy"
        view.layoutIfNeeded()
        presentOpportunityToAddDetails()
    }
    
    func didCancelMoodChange() {
        UIView.animateWithDuration(0.2, animations: {
            self.moodDescriptionView.alpha = 0.0
        })

        self.delegate?.didEndEditingMood()
    }
}
