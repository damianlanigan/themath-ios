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

class JournalViewController: GAITrackedViewController, UITextViewDelegate {
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryViews: [CategoryView]!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        println(results)
    }
    
    // MARK: Setup
    
    private func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // MARK: Notifications
    
    func keyboardWillShow(notification: NSNotification!) {
        let info = notification.userInfo
        if let info = info {
            if let keyboardSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
                if let animationDuration: Double = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                    
                    let height = keyboardSize.size.height
                    saveButtonBottomConstraint.constant = height
                    
//                    scrollView.contentSize.height += height
//                    scrollView.setContentOffset(CGPointMake(0, height / 2), animated: true)
                    
                    var bounds = scrollView.bounds
                    let animation = CABasicAnimation(keyPath: "bounds")
                    animation.duration = animationDuration
                    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    animation.fromValue = NSValue(CGRect: bounds)
                    bounds.origin.y = height / 2.0
                    animation.toValue = NSValue(CGRect: bounds)
                    
                    scrollView.layer.addAnimation(animation, forKey: "bounds")
                    scrollView.bounds = bounds;
                    
                    UIView.animateWithDuration(animationDuration, animations: {
                        self.view.layoutIfNeeded()
                    })
                    
                }
            }
        }
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
