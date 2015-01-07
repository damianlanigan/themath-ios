//
//  ViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JournalViewControllerDelegate {

    @IBOutlet weak var subviewContainerView: UIView!
    
    @IBOutlet weak var journalButton: UIButton!
    
    @IBOutlet weak var moodButton: UIButton!
    
    var onMood: Bool = true
    
    var moodViewController: MoodViewController?
    
    var journalViewController: JournalViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showMoodController()
    }
    @IBAction func journalButtonTapped(sender: AnyObject) {
        showJournalController()
    }
    
    @IBAction func moodButtonTapped(sender: UIButton) {
        showMoodController()
    }
    
    private func loadMoodController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        moodViewController = storyboard.instantiateViewControllerWithIdentifier("MoodViewController") as? MoodViewController
        _addContentViewController(moodViewController!, toView: subviewContainerView)
    }
    
    private func loadJournalController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        journalViewController = storyboard.instantiateViewControllerWithIdentifier("JournalViewController") as? JournalViewController
        journalViewController?.delegate = self
        _addContentViewController(journalViewController!, toView: subviewContainerView)
    }
    
    private func showMoodController() {
        
        if moodViewController == nil {
            loadMoodController()
        }
        
        journalViewController?.view.hidden = true
        moodViewController?.view.hidden = false
        
        journalButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        moodButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        onMood = true
        
        moodButton.alpha = 1.0
        journalButton.alpha = 0.45
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func showJournalController() {
        
        if journalViewController == nil {
            loadJournalController()
        }
        
        moodViewController?.view.hidden = true
        journalViewController?.view.hidden = false
        
        journalButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        moodButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        
        onMood = false
        
        journalButton.alpha = 1.0
        moodButton.alpha = 0.45
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return onMood ? .LightContent : .Default
    }
    
    func didBeginEditingMood() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            self.journalButton.alpha = 0.0
            self.moodButton.alpha = 0.0
            }) { (done: Bool) -> Void in
                return()
        }
    }
    
    func didEndEditingMood() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            self.journalButton.alpha = 1.0
            self.moodButton.alpha = 0.45
        }) { (done: Bool) -> Void in
            return()
        }
    }
}
