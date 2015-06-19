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
        journalEntry.commitForSave = true
        journalEntry.save { () -> Void in
            // hide spinner
            SwiftLoader.hide()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func dismissButtonTapped(sender: AnyObject) {
        isCancelled = true
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Setup
    
    private func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // THIS HAPPENS WHEN LOCATION PERMISSIONS ARE DETERMINED
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
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
        if LocationCoordinator.isActive() || LocationCoordinator.needsRequestAuthorization() {
            println("starting or requesting permissions")
            LocationCoordinator.activate()
            LocationCoordinator.sharedCoordinator.requestAuthorization()
            LocationCoordinator.sharedCoordinator.delegate = self
            LocationCoordinator.sharedCoordinator.start()
        } else {
            LocationCoordinator.deactivate()
            println("we don't have location permissions")
        }
    }
    
    // MARK: Notifications
    
    func applicationDidBecomeActive() {
        setupLocationServices()
    }
    
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
            self.scrollView.backgroundColor = UIColor.mood_initialColor()
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
    
    private func currentDateTimeFormatted() -> String {
        let formatter = NSDateFormatter()
        let date = NSDate()
        
        formatter.dateFormat = "mm"
        var minute = formatter.stringFromDate(date)
        minute = count(minute) < 2 ? "0\(minute)" : minute
        
        formatter.dateFormat = "h"
        var hour = formatter.stringFromDate(date)
        
        formatter.dateFormat = "EEEE"
        let weekday = formatter.stringFromDate(date)
        
        formatter.dateFormat = "a"
        let aORp = formatter.stringFromDate(date)
        
        return "\(weekday) • \(hour):\(minute) \(aORp)"
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // <LocationCoordinatorDelegate>
    
    func locationCoordinator(coordinator: LocationCoordinator, didReceiveLocation location: CLLocation) {
        journalEntry.addLocation(location)
        coordinator.stop() // we only need 1 location
    }
    
}
