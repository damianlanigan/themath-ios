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

class JournalEntry {
    var categories: [String] = [String]()
    var note = ""
    var score: Int!
    var timestamp: NSDate!
    var lat: Double?
    var lng: Double?
    
    func save(completion: () -> Void) {
        request(Router.CreateJournalEntry(["journal_entry" : asJSON()])).responseJSON { (request, response, data, error) in
            if let data = data as? [String: AnyObject] {
                if let errors = data["errors"] as? [String: [String]] {
                    println("something went wrong")
                } else {
                    completion()
                }
            }
        }
    }
    
    private func asJSON() -> [String: AnyObject] {
        var json = [
            "score" : score,
            "timestamp" : timestamp,
            "categories" : categories,
            "note" : note // TODO: shouldn't save if says "Add a note..."
        ]
        if let lat = lat {
            json["lat"] = lat
        }
        if let lng = lng {
            json["lng"] = lng
        }
        return json
    }
    
    class func fromJSONRequest(json: [String:AnyObject]) -> JournalEntry {
        println(json)
        let entry = JournalEntry()
        entry.note = json["note"] as! String
        entry.categories = json["categories"] as! [String]
        entry.lat = json["lat"] as? Double
        entry.lng = json["lng"] as? Double
        entry.score = json["score"] as! Int
        
        let dateString = json["timestamp"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(abbreviation: "GMT")
        let date = formatter.dateFromString(dateString)
        
        var offset = NSTimeZone.localTimeZone().secondsFromGMT / 60 / 60
        var components = NSDateComponents()
        components.setValue(date!.year(), forComponent: NSCalendarUnit.CalendarUnitYear)
        components.setValue(date!.month(), forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(date!.day(), forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(date!.hour(offset: offset), forComponent: NSCalendarUnit.CalendarUnitHour)
        components.setValue(date!.minute(), forComponent: NSCalendarUnit.CalendarUnitMinute)
        components.setValue(date!.seconds(), forComponent: NSCalendarUnit.CalendarUnitSecond)

        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        entry.timestamp = calendar.dateFromComponents(components)
        
        return entry
    }
    
}

class JournalViewController: UIViewController, UITextViewDelegate {
    
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

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentViewHeightConstraint.constant = view.frame.size.height - 44.0
        contentViewWidthConstraint.constant = view.frame.size.width
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        textView.resignFirstResponder()
        var selections = categoryViews.filter({ $0.selected }).map({ $0.name() })
        
//        journalEntry.lat = 
//        journalEntry.lng = 
        journalEntry.categories = selections
        journalEntry.note = textView.text
        journalEntry.save { () -> Void in
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
    }
    
    private func setColors() {
        scrollView.backgroundColor = transitionColor!
        contentView.backgroundColor = UIColor.journal_tintColor()
        let buttonColor = UIColor.colorAtPercentage(transitionColor!, color2: UIColor.journal_tintColor(), perc: 0.2)
        saveButton.setTitleColor(buttonColor, forState: .Normal)
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
}
