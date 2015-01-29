//
//  👨
// 
//  ViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JournalViewControllerDelegate, MoodViewControllerDelegate, OnboardingViewControllerDelegate {

    @IBOutlet weak var subviewContainerView: UIView!
    
    @IBOutlet weak var journalButton: UIButton!
    
    @IBOutlet weak var moodButton: UIButton!
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var contentContainerView: UIView!
    
    var laid = false
    
    var onMood = false
    
    var onOnboarding = true
    
    lazy var moodViewController: MoodViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MoodViewController") as? MoodViewController
        viewController?.delegate = self
        return viewController!
    }()
    
    lazy var journalViewController: JournalViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("JournalViewController") as? JournalViewController
        viewController?.delegate = self
        return viewController!
    }()
    
    lazy var onboardingViewController: OnboardingViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as? OnboardingViewController
        viewController?.delegate = self
        return viewController!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMoodController()
        loadJournalController()
        
        showMoodController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !laid {
            laid = true
            showOnboardingController()
        }
    }
    
    @IBAction func journalButtonTapped(sender: AnyObject) {
        showJournalController()
    }
    
    @IBAction func moodButtonTapped(sender: UIButton) {
        showMoodController()
    }
    
    private func loadMoodController() {
        _addContentViewController(moodViewController, toView: subviewContainerView)
    }
    
    private func loadJournalController() {
        _addContentViewController(journalViewController, toView: subviewContainerView)
    }
    
    private func showOnboardingController() {
        _addContentViewController(onboardingViewController, aboveView: contentContainerView)
    }
    
    private func hideOnboardingController() {
        _removeContentViewController(onboardingViewController)
    }
    
    private func showMoodController() {
    
        journalViewController.view.hidden = true
        moodViewController.view.hidden = false
        
        journalButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        moodButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        onMood = true
        
        moodButton.alpha = 1.0
        journalButton.alpha = 0.45
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func showJournalController() {
    
        moodViewController.view.hidden = true
        journalViewController.view.hidden = false
        
        journalButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        moodButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        
        onMood = false
        
        journalButton.alpha = 1.0
        moodButton.alpha = 0.45
        
        setNeedsStatusBarAppearanceUpdate()
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
    
    // MARK: <MoodViewControllerDelegate>
    
    func didBeginNewMood() {
        UIView.animateWithDuration(0.2, animations: {
            self.journalButton.alpha = 0.0
            self.moodButton.alpha = 0.0
        })

    }
    
    func didEndNewMood() {
        UIView.animateWithDuration(0.2, delay: 0.2, options: .CurveLinear, animations: {
            self.journalButton.alpha = 11.0
            self.moodButton.alpha = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return  onMood ? .LightContent : .Default
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return onOnboarding
    }
    
    // MARK: <OnboardingViewControllerDelegate>
    
    func didFinishOnboarding() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.onboardingViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y - self.view.frame.size.height)
            }) { (done: Bool) -> Void in
                self.hideOnboardingController()
        }
    }
}
