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
import MessageUI

class ViewController: UIViewController,
JournalViewControllerDelegate,
MoodViewControllerDelegate,
OnboardingViewControllerDelegate,
UIAlertViewDelegate,
MFMailComposeViewControllerDelegate,
UINavigationControllerDelegate,
UIScrollViewDelegate {

    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: INSTANCE VARIABLES
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    

    @IBOutlet weak var moodContainerView: UIView!
    @IBOutlet weak var journalContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var journalButton: UIButton!
    @IBOutlet weak var moodButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    
    var currentOrientation: UIDeviceOrientation = .Portrait
    var previousScrollPercentage: CGFloat = 0.0
    
    var laid = false
    var onMood = true
    var onOnboarding = false
    var isCommenting = false
    var isSubmittingFeedback = false
    
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

    lazy var infographViewController: InfographViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("Infograph") as? InfographViewController
        return viewController!
    }()
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: LIFECYCLE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMoodController()
        loadJournalController()
        
        journalButton.alpha = 0.2
        
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !laid {
            laid = true
            
            contentViewWidthConstraint.constant = view.frame.size.width * 2.0
            contentViewHeightConstraint.constant = view.frame.size.height
            scrollView.contentSize = CGSizeMake(contentViewWidthConstraint.constant, contentViewHeightConstraint.constant)
            
            showOnboardingController()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setupNavigationBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 16)!]
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 16)!], forState: .Normal)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name:
            UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: IBACTION
    
    
    @IBAction func journalButtonTapped(sender: AnyObject) {
        showJournalController()
    }
    
    @IBAction func moodButtonTapped(sender: UIButton) {
        showMoodController()
    }
    
    func orientationDidChange(notification: NSNotification) {
        if !onOnboarding {
            if let device = notification.object as? UIDevice {
                if device.orientation.isLandscape && !currentOrientation.isLandscape {
                    showInfograph()
                } else if device.orientation.isPortrait && !currentOrientation.isPortrait {
                    hideInfograph()
                }
                currentOrientation = device.orientation
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        if onOnboarding {
            return false
        }
        if isCommenting {
            return false
        }
        if isSubmittingFeedback {
            return false
        }
        return true
    }

    private func loadMoodController() {
        _addContentViewController(moodViewController, toView: moodContainerView)
    }
    
    private func loadJournalController() {
        _addContentViewController(journalViewController, toView: journalContainerView)
    }
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: STATE - UIVIEWCONTROLLER
    
    // MARK: Onboarding
    
    private func showOnboardingController() {
        onOnboarding = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as? OnboardingViewController
        viewController?.delegate = self
        _addContentViewController(viewController!, aboveView: contentContainerView)
    }

    
    // MARK: Category Selection
    
    private func showCategorySelectionController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("CategorySelection") as? OnboardingViewController
        viewController?.delegate = self
    }
    
    private func hideCategorySelectionController() {
        
    }
    
    // MARK: Mood
    
    private func showMoodController() {
        scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    // MARK: Journal
    
    private func showJournalController() {
        scrollView.setContentOffset(journalContainerView.frame.origin, animated: true)
    }
    
    // MARK: Infograph
    
    private func showInfograph() {
        if shouldAutorotate() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("Infograph") as? InfographViewController
            presentViewController(viewController!, animated: false, completion: nil)
        }
    }
    
    private func hideInfograph() {
        if shouldAutorotate() {
            dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    // MARK: Login
    
    private func presentLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginController") as LoginViewController
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    // MARK: Feedback
    
    private func showFeedbackEmail() {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setSubject("HowAmIDoing Feedback")
        viewController.setToRecipients(["usehowamidoing@gmail.com"])
        presentViewController(viewController, animated: true, completion: nil)
        isSubmittingFeedback = true
    }
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <JournalViewControllerDelegate>

    
    func didBeginEditingJournalCategory() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            self.journalButton.alpha = 0.0
            self.moodButton.alpha = 0.0
            }) { (done: Bool) -> Void in
                return()
        }
    }
    
    func didEndEditingJournalCategory() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            self.journalButton.alpha = 1.0
            self.moodButton.alpha = 0.45
        }) { (done: Bool) -> Void in
            return()
        }
    }
    
    func didBeginCommenting() {
        isCommenting = true
    }
    
    func didEndCommenting() {
        isCommenting = false
    }
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <MoodViewControllerDelegate>

    
    func didBeginNewMood() {
        UIView.animateWithDuration(0.2, animations: {
            self.journalButton.alpha = 0.0
            self.moodButton.alpha = 0.0
        })

    }
    
    func didEndNewMood() {
        UIView.animateWithDuration(0.2, delay: 0.2, options: .CurveLinear, animations: {
            self.journalButton.alpha = 0.2
            self.moodButton.alpha = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
    }
    
    func shouldReplayOnboarding() {
        let alert = UIAlertView(title: "Settings", message: "", delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles: "Replay tutorial", "Submit feedback")
        alert.show()
    }
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <OnboardingViewControllerDelegate>
    
    
    func didFinishOnboarding(viewController: OnboardingViewController) {
        onOnboarding = false
        setNeedsStatusBarAppearanceUpdate()
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                viewController.view.center = CGPointMake(self.view.center.x, self.view.center.y - self.view.frame.size.height)
            }) { (done: Bool) -> Void in
                self._removeContentViewController(viewController)
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <UIAlertViewDelegate>
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            showOnboardingController()
            Tracker.track("onboarding", action: "replayed", label: "")
        } else if buttonIndex == 2 {
            showFeedbackEmail()
            Tracker.track("send feedback", action: "tapped", label: "")
        }
    }
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <UIAlertViewDelegate>

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        isSubmittingFeedback = false
    }
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <UIScrollViewDelegate>
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let white = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
            let black = UIColor(red: 100/255.0, green: 100/255.0, blue:100/255.0, alpha: 1.0)
            let percentage = scrollView.contentOffset.x / view.frame.size.width
            let color = UIColor.colorAtPercentage(white, color2: black, perc: percentage)
            let moodAlpha = max(1 - percentage, 0.2)
            let journalAlpha = max(percentage, 0.2)

            moodButton.setTitleColor(color, forState: .Normal)
            moodButton.alpha = moodAlpha
            
            journalButton.setTitleColor(color, forState: .Normal)
            journalButton.alpha = journalAlpha
            
            if percentage < 0.5 && previousScrollPercentage >= 0.5 {
                onMood = true
                setNeedsStatusBarAppearanceUpdate()
            } else if percentage > 0.5 && previousScrollPercentage <= 0.5 {
                onMood = false
                setNeedsStatusBarAppearanceUpdate()
            }
            
            previousScrollPercentage = percentage
        }
    }
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: UTILITY
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return  onMood ? .LightContent : .Default
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return onOnboarding
    }
    
}
