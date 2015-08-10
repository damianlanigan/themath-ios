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
import CoreLocation
import SwiftLoader

class JournalViewController: UIViewController,
    UITextViewDelegate,
    UIAlertViewDelegate,
    LocationCoordinatorDelegate {
    
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
    
    var isCancelled = false
    var transitionColor: UIColor?
    var cachedScrollViewHeight: CGFloat = 0.0
    var mood: Int = 0
    var location: CLLocation?
    
    // Vendor
    
    /////////
    
    var journalEntry = JournalEntry()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setColors()
        
        dateLabel.text = currentDateTimeFormatted()
        textView.delegate = self
        
        journalEntry.score = self.mood
        journalEntry.timestamp = NSDate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLocationServices()
    }
    
    deinit {
        LocationCoordinator.sharedCoordinator.delegate = nil
        LocationCoordinator.sharedCoordinator.stop()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentViewHeightConstraint.constant = view.frame.size.height - 44.0
        contentViewWidthConstraint.constant = view.frame.size.width
    }
    
    // MARK: IBAction
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        // show spinner
        SwiftLoader.show(animated: true)
        textView.resignFirstResponder()
        var selections = categoryViews.filter({ $0.selected }).map({ $0.name() })
        
        if let location = location {
            journalEntry.lat = location.coordinate.latitude
            journalEntry.lng = location.coordinate.longitude
            journalEntry.locationAccuracy = location.horizontalAccuracy
        }
        
        journalEntry.categories = selections.map { CategoryType(rawValue: $0.capitalizedString )! }
        journalEntry.note = textView.text
        journalEntry.save { () -> Void in
            // hide spinner
            Account.currentUser().latestEntry = self.journalEntry
            SwiftLoader.hide()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func dismissButtonTapped(sender: AnyObject) {
        let alert = UIAlertView(title: "Are you sure you want to delete this draft?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles:"Delete draft")
        alert.show()
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
    
    // This is the only method that needs to be called 
    // in order to enable location on posts. This method
    // will request authorization if needed and start
    // updating locations. It will do nothing if permissions
    // are turned off
    private func setupLocationServices() {
        if LocationCoordinator.isActive() {
            println("starting or requesting permissions")
            LocationCoordinator.sharedCoordinator.delegate = self
            LocationCoordinator.sharedCoordinator.start()
        } else {
            println("we don't have location permissions")
        }
    }
    
    // MARK: Notifications
    func keyboardWillShow(notification: NSNotification!) {
        cachedScrollViewHeight = scrollView.contentSize.height
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
                    
                    scrollView.contentSize.height = cachedScrollViewHeight + height
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
                    scrollView.contentSize.height = cachedScrollViewHeight
                    cachedScrollViewHeight = 0.0
                    UIView.animateWithDuration(animationDuration, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    // MARK: Exit transition animations
    
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
            self.scrollView.backgroundColor = UIColor.mood_latestMoodColor()
            self.savedLabel.alpha = 0.0
            if self.isCancelled {
                self.contentView.alpha = 0.0
                self.contentView.transform = CGAffineTransformMakeScale(0.92, 0.92)
            }
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
    
    // MARK: UITextFieldDelegate

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Give some context to what's happening..." {
            textView.text = ""
            textView.textColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Give some context to what's happening..."
            textView.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        }
    }
    
    // MARK: LocationCoordinatorDelegate
    
    func locationCoordinator(coordinator: LocationCoordinator, didReceiveLocation location: CLLocation) {
        journalEntry.addLocation(location)
        coordinator.stop() // we only need 1 location
    }
    
    // MARK: UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            isCancelled = true
            textView.resignFirstResponder()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: Utility - Date Helper
    
    private func currentDateTimeFormatted() -> String {
        let formatter = NSDateFormatter()
        let date = NSDate()
        
        formatter.dateFormat = "mm"
        var minute = formatter.stringFromDate(date)
        minute = count(minute) < 2 ? "0\(minute)" : minute
        
        formatter.dateFormat = "h"
        var hour = formatter.stringFromDate(date)
        
        formatter.dateFormat = "a"
        let aORp = formatter.stringFromDate(date)
        
        return "\(hour):\(minute) \(aORp)"
    }


    // MARK: Behavior
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
}
