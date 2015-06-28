//
//  👨🏻
//
//  MoodViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import MessageUI

class MoodViewController: UIViewController,
    OnboardingViewControllerDelegate,
    SettingsTableViewControllerDelegate,
    UIAlertViewDelegate,
    MFMailComposeViewControllerDelegate,
    UINavigationControllerDelegate,
    UIViewControllerTransitioningDelegate {
    
//    @IBOutlet weak var latestMoodLabel: CabritoLabel!
    
    private var currentMood = 0
    
    var transitionColor: UIColor?

    @IBOutlet weak var moodCircle: RoundableView!
    
    // MARK: state
    
    private var capturingMood = false
    private var firstAppearance = true
    private var onMood = true
    private var previousOrientation: UIDeviceOrientation = .Portrait
    
    lazy var backgroundGradient: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.colors = [
            UIColor.mood_endColor().CGColor,
            UIColor.colorAtPercentage(UIColor.mood_endColor(), color2: UIColor.mood_startColor(), perc: 0.5).CGColor,
            UIColor.mood_startColor().CGColor
        ]
        gl.locations = [0.0, 0.7, 1.0]
        return gl
    }()
    
    lazy var infographViewController: InfographViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("Infograph") as? InfographViewController
        return viewController!
    }()
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.0
//        view.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: 0.5)
        
        view.layer.addSublayer(backgroundGradient)
        backgroundGradient.frame = view.layer.bounds
        
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLatestTimestamp();
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppearance {
            firstAppearance = false
            
            
            // THIS CALL SETS THE ACCESS TOKEN FOR AUTHENTICATED
            // API REQUESTS
            if !Account.sharedAccount().isAuthenticated() {
                presentOnboarding()
            }
            
            updateLatestTimestamp();
            
            _performBlock({ () -> Void in
                UIView.animateWithDuration(0.2, animations: {
                    self.view.alpha = 1.0
                })
            }, withDelay: 0.3)
            
            
        }
        
        UIView.animateWithDuration(0.3, animations: {
//            self.latestMoodLabel.alpha = 1.0
        })
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: SETUP
    
    // MARK: viewcontroller
    
    private func setup() {
        setupNotificationObservers()
        setupGestureRecognizers()
    }
    
    private func setupNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    private func setupGestureRecognizers() {
        let gesture = UIPanGestureRecognizer(target: self, action: "panMoodCircle:")
        moodCircle.addGestureRecognizer(gesture)
    }
    
    func panMoodCircle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            println("began")
        case .Changed:
            let point = gesture.locationInView(view) // translationInView(view)
            self.moodCircle.center = point
            
            let y: CGFloat = 1 - (self.moodCircle.center.y / self.view.frame.size.height)
            // ((high - low) / 0.5) * y + low
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            backgroundGradient.locations = [0.0, 0.4 * y + 0.3, 1.0]
            CATransaction.commit()
            
        case .Ended:
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.moodCircle.center = self.view.center
                    self.view.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc:
                0.5)
                }, completion: { (_: Bool) -> Void in
            })
        default:
            return
        }
>>>>>>> rip out old code add in new code
    }
    
    private func updateLatestTimestamp() {
        request(Router.LatestJournalEntry()).responseJSON { (request, response, data, error) in
            if let data = data as? [String: AnyObject] {
                let entry = JournalEntry.fromJSONRequest(data)
                let lastMood = "Last mood\n"
                let timestamp = "\(entry.timestamp.relativeTimeToString())"
                var string = NSMutableAttributedString(string: "\(lastMood) \(timestamp)")
                let color = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: CGFloat(entry.score) / 100.0)
                let range = NSMakeRange(count(lastMood), count(" \(timestamp)"))
                string.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
//                self.latestMoodLabel.attributedText = string
            } else {
//                self.latestMoodLabel.text = ""
            }
        }
    }

    
    // MARK: IBACTION
    
    @IBAction func replayOnboardingButtonTapped(sender: UIButton) {
        let alert = UIAlertView(title: "Settings", message: "", delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles: "Replay tutorial", "Send feedback")
        alert.show()
    }
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    private func showFeedbackEmail() {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setSubject("HowAmIDoing Feedback")
        viewController.setToRecipients(["usehowamidoing@gmail.com"])
        presentViewController(viewController, animated: true, completion: nil)
        onMood = false
    }
    
    // MARK: NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? JournalViewController {
//            viewController.transitionColor = UIColor(CGColor: color)
            viewController.transitioningDelegate = self
            viewController.mood = currentMood
            viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        } else if let viewController = segue.destinationViewController as? InfographViewController {
            viewController.transitioningDelegate = self
            viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        } else if let viewController = segue.destinationViewController as? NonRotatingNavigationController {
            if let otherController = viewController.viewControllers[0] as? SettingsTableViewController {
                otherController.delegate = self
            }
        }
    }
    
    private func presentInfograph() {
        if shouldAutorotate() {
            UIView.animateWithDuration(0.2, animations: {
                self.view.alpha = 0.0
            })
            if let viewController = presentedViewController as? InfographViewController {
                
            } else {
                performSegueWithIdentifier("PresentInfograph", sender: self)
            }

        }
    }
    
    private func dismissInfograph() {
        if shouldAutorotate() {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func presentOnboarding() {
        onMood = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as! OnboardingViewController
        presentViewController(viewController, animated: false, completion: nil)
        viewController.delegate = self
    }
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: UTILITY


    override func prefersStatusBarHidden() -> Bool {
        return capturingMood
    }

    override func shouldAutorotate() -> Bool {
        if let viewController = presentedViewController as? InfographViewController {
            return !viewController.orientationLocked
        } else if let viewController = presentedViewController as? NonRotatingNavigationController {
            return false
        }
        return onMood
    }
    
    func orientationDidChange(notification: NSNotification) {
        if shouldAutorotate() {
            if let device = notification.object as? UIDevice {
                if device.orientation.isLandscape && !previousOrientation.isLandscape {
                    presentInfograph()
                } else if device.orientation.isPortrait && !previousOrientation.isPortrait {
                    dismissInfograph()
                }
                previousOrientation = device.orientation
            }
        }
    }

    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <MoodViewDelegate>


    func moodViewTouchesBegan() {
        beginMood()
    }

    func moodViewTouchesEnded() {
        endMood()
    }
    
    private func beginMood() {
        capturingMood = true
        setNeedsStatusBarAppearanceUpdate()
        
        UIView.animateWithDuration(0.3, animations: {
//            self.latestMoodLabel.alpha = 0.0
        })
    }
    
    private func endMood() {
        capturingMood = false
        
        // for API
//        let percentage = trunc(currentTime / animationDuration * 100)
//        println("Mood: \(percentage)%")
        
//        currentMood = Int(percentage)
        
        
        self.performSegueWithIdentifier("MoodToJournalTransition", sender: self)

        _performBlock({ () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }, withDelay: 0.9 )
        
//        Analytics.track("mood", action: "set", label: "\(percentage)%")
    }
    
    // MARK: <OnboardingViewControllerDelegate>
    
    func didFinishOnboarding(viewController: OnboardingViewController) {
        onMood = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <UIAlertViewDelegate>
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            presentOnboarding()
            Analytics.track("onboarding", action: "replayed", label: "")
        } else if buttonIndex == 2 {
            showFeedbackEmail()
            Analytics.track("send feedback", action: "tapped", label: "")
        }
    }
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <UIAlertViewDelegate>
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        onMood = true
    }
    
    // MARK: <SettingsTableViewControllerDelegate>
    
    func didLogout() {
        dismissViewControllerAnimated(false, completion: {
            self.presentOnboarding()
        })
    }
    
    // MARK: <UIViewControllerTransitioningDelegate>
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let viewController = presented as? JournalViewController {
            onMood = false
            let animator = MaskAnimationController()
            animator.presenting = true
            return animator
        } else if let viewController = presented as? InfographViewController {
            let animator = FadeAnimationController()
            animator.presenting = true
            return animator
        }

        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        onMood = true
        if let viewController = dismissed as? JournalViewController {
            return MaskAnimationController()
        } else if let viewController = dismissed as? InfographViewController {
            return FadeAnimationController()
        }
        
        return nil
    }
}
