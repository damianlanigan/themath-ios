//
//  👨🏻
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

    @IBOutlet weak var moodContainerView: UIView!
    
    var currentOrientation: UIDeviceOrientation = .Portrait
    
    var laid = false
    var onMood = true
    var onOnboarding = false
    var isCommenting = false
    var isSubmittingFeedback = false
    var firstAppearance = true
    
    lazy var moodViewController: MoodViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MoodViewController") as? MoodViewController
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
        setupNavigationBar()
        setupNotificationObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstAppearance {
            firstAppearance = false
            showOnboardingController()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setupNavigationBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 16)!]
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 16)!], forState: .Normal)
    }
    
    private func setupNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name:
            UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: IBACTION
    
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
        return false
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

    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: STATE - UIVIEWCONTROLLER
    
    // MARK: Onboarding
    
    private func showOnboardingController() {
        onOnboarding = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as? OnboardingViewController
        viewController?.delegate = self
        _addContentViewController(viewController!, aboveView: moodContainerView)
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
        let viewController: LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginViewController
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
    
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <MoodViewControllerDelegate>

    
    func didBeginNewMood() {
        println("didBeginNewMood")
    }
    
    func didEndNewMood() {
        println("didEndNewMood")
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
    
    // MARK: UTILITY
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return  onMood ? .LightContent : .Default
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
