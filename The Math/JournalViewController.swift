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
    
    @IBOutlet weak var moodDescriptionView: UIView!
    
    @IBOutlet weak var categoryContainerView: UIView!
    
    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var moodDescriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var youreFeelingLabel: UILabel!
    @IBOutlet weak var additionalFeelingTextLabel: UILabel!
    
    lazy var categories: [Category] = {
        return [
            Category(type: .Personal),
            Category(type: .Lifestyle),
            Category(type: .Love),
            Category(type: .Health),
            Category(type: .Money)
        ]
    }()
    
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var commentViewTopConstraint: NSLayoutConstraint!
    
    var firstAppearance = true
    
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstAppearance {
            firstAppearance = false
            showToolTip()
            
            let screenWidth = view.frame.size.width
            let numberOfCategories = categories.count
            for (idx, category) in enumerate(categories) {
                let view: CategoryView = UIView.viewFromNib("CategoryView") as CategoryView
                view.category = category
                let x = CGFloat(idx) * screenWidth / CGFloat(numberOfCategories)
                let y = CGFloat(0.0)
                let width = screenWidth / CGFloat(numberOfCategories)
                let height = categoryContainerView.frame.size.height
                view.frame = CGRectMake(x, y, width, height)
                view.delegate = self
                categoryContainerView.addSubview(view)
            }
        }
    }
    
    func showToolTip() {
        AMPopTip.appearance().textColor = UIColor.blackColor()
        AMPopTip.appearance().textAlignment = .Center
        
        var titleString = NSMutableAttributedString(string: "Slide up or down")
        var bodyString = NSMutableAttributedString(string: "\nWhen you rotate your phone sideways you’ll be able to see your inputs over time.")
        let titleRange = NSMakeRange(0, countElements(titleString.string))
        let bodyRange = NSMakeRange(0, countElements(bodyString.string))
        let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 16)!
        let bodyFont = UIFont(name: "AvenirNext-Medium", size: 16)!
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        titleString.addAttributes([
            NSFontAttributeName : titleFont,
            NSParagraphStyleAttributeName : paragraphStyle
        ], range: titleRange)
        
        bodyString.addAttributes([
            NSFontAttributeName : bodyFont,
            NSParagraphStyleAttributeName : paragraphStyle
        ], range: bodyRange)
        
        titleString.appendAttributedString(bodyString)
        
        var fromFrame = CGRectZero
        fromFrame.origin.x = view.center.x
        fromFrame.origin.y = view.center.y + 10
        
        toolTip.showAttributedText(titleString, direction: .Up, maxWidth: 280, inView: view, fromFrame: fromFrame)
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
        
        commentViewTopConstraint.constant = 0
        
        self.overlayView.hidden = false
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
        
        commentViewTopConstraint.constant = -171
        
        UIView.animateWithDuration(0.4, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 0.0
            
            }) { (done: Bool) -> Void in
                self.overlayView.hidden = false
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
        
        switch mood {
        case .Great:
            additionalFeelingTextLabel.text = "Thats awesome! Good to hear."
        case .Good:
            additionalFeelingTextLabel.text = "Let the good times roll."
        case .Bad:
            additionalFeelingTextLabel.text = "Somedays just aren’t yours."
        case .Horrible:
            additionalFeelingTextLabel.text = "Let it all out in a comment."
        default:
            additionalFeelingTextLabel.text = ""
        }
        
        view.layoutIfNeeded()
        presentOpportunityToAddDetails()
        
        // for API
        println("Category rated: \(category.type.rawValue) - \(mood.rawValue)")
    }
    
    func didCancelMoodChange() {
        UIView.animateWithDuration(0.2, animations: {
            self.moodDescriptionView.alpha = 0.0
        })

        self.delegate?.didEndEditingMood()
    }
}
