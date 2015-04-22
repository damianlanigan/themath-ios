//
//  👨🏻
//
//  JournalViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol JournalViewControllerDelegate {
    
}

struct JournalEntry {
    let categories: [String:AnyObject]
    let note: String

}

class JournalViewController: GAITrackedViewController, UITextViewDelegate {
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryViews: [CategoryView]!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savedLabel: UILabel!
    
    var transitionColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mood_startColor()
        setupObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setColors()
        
        dateLabel.text = currentDateTimeFormatted()
        textView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentViewHeightConstraint.constant = view.frame.size.height
        contentViewWidthConstraint.constant = view.frame.size.width
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        var results = [String: AnyObject]()
        var selections = categoryViews.map({ results[$0.name()] = $0.selected })
        var final = JournalEntry(categories: results, note: textView.text)
        println(final)
    }
    
    // MARK: Setup
    
    private func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func setColors() {
        scrollView.backgroundColor = transitionColor!
        contentView.backgroundColor = UIColor.journal_tintColor()
        let buttonColor = UIColor.colorAtPercentage(transitionColor!, color2: UIColor.journal_tintColor(), perc: 0.2)
        saveButton.setTitleColor(buttonColor, forState: .Normal)
    }
    
    // MARK: Notifications
    
    func keyboardWillShow(notification: NSNotification!) {
        let info = notification.userInfo
        if let info = info {
            if let keyboardSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
                if let animationDuration: Double = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                    
                    let height = keyboardSize.size.height
                    saveButtonBottomConstraint.constant = height
                    
                    var bounds = scrollView.bounds
                    let animation = CABasicAnimation(keyPath: "bounds")
                    animation.duration = animationDuration
                    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    animation.fromValue = NSValue(CGRect: bounds)
                    bounds.origin.y = height / 2.0
                    animation.toValue = NSValue(CGRect: bounds)
                    
                    scrollView.contentSize.height += height
                    scrollView.layer.addAnimation(animation, forKey: "bounds")
                    scrollView.bounds = bounds;
                    
                    UIView.animateWithDuration(animationDuration, animations: {
                        self.view.layoutIfNeeded()
                    })
                    
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        let info = notification.userInfo
        if let info = info {
            if let keyboardSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
                if let animationDuration: Double = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                    saveButtonBottomConstraint.constant = 0
                    UIView.animateWithDuration(animationDuration, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    func fadeOutInitial(duration: NSTimeInterval, completion: () -> Void) {
        UIView.animateWithDuration(duration, animations: {
            self.contentView.alpha = 0.0
            self.contentView.transform = CGAffineTransformMakeScale(0.92, 0.92)
            }) { (done: Bool) -> Void in
                completion()
        }
    }
    
    func fadeOutFinal(duration: NSTimeInterval, completion: () -> Void) {
        UIView.animateWithDuration(duration, animations: {
            self.scrollView.backgroundColor = UIColor.mood_startColor()
            self.savedLabel.alpha = 0.0
//            self.savedLabel.transform = CGAffineTransformMakeScale(0.86, 0.86)
            }) { (done: Bool) -> Void in
                completion()
        }
    }
    
    func saved() {
        UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.savedLabel.alpha = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
    }
    
    private func currentDateTimeFormatted() -> String {
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "mm"
        var minute = formatter.stringFromDate(NSDate())
        minute = count(minute) < 2 ? "0\(minute)" : minute
        
        formatter.dateFormat = "h"
        var hour = formatter.stringFromDate(NSDate())
        hour = count(hour) < 2 ? "0\(hour)" : hour
        
        formatter.dateFormat = "EEEE"
        let weekday = formatter.stringFromDate(NSDate())
        
        formatter.dateFormat = "a"
        let aorp = formatter.stringFromDate(NSDate())
        return "\(weekday) • \(hour):\(minute) \(aorp)"
    }


    // <UITextFieldDelegate>

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Add a note..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a note..."
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
