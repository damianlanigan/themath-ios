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

enum MoodTransitions: String {
    case ToJournal = "MoodToJournalTransition"
}

class MoodViewController: UIViewController,
    OnboardingViewControllerDelegate,
    SettingsTableViewControllerDelegate,
    UIAlertViewDelegate,
    MFMailComposeViewControllerDelegate,
    UINavigationControllerDelegate,
    UIViewControllerTransitioningDelegate,
    TouchableDelegate {
    
    let CancelMoodDistanceThreshold: CGFloat = 60.0
    
    @IBOutlet weak var latestMoodLabel: CabritoLabel!

    @IBOutlet weak var moodCircle: RoundableView!
    @IBOutlet weak var ratingHighImageView: UIImageView!
    @IBOutlet weak var ratingLowImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    // MARK: state
    
    private var currentMood = 0
    private var firstAppearance = true
    private var onMood = true
    private var previousOrientation: UIDeviceOrientation = .Portrait
    private var transitionColor = UIColor.whiteColor()
    private var moodEnding = false
    private var capturingMood = false
    
    lazy var topBackgroundGradient: CAGradientLayer = {
       let g = CAGradientLayer()
        g.colors = [
            UIColor.mood_endColor().CGColor,
            UIColor.mood_endColor().colorWithAlphaComponent(0.0).CGColor
        ]
        g.locations = [0.0, 0.5]
        g.frame = self.view.bounds
        return g
    }()
    
    lazy var bottomBackgroundGradient: CAGradientLayer = {
       let g = CAGradientLayer()
        g.colors = [
            UIColor.mood_startColor().colorWithAlphaComponent(0.0).CGColor,
            UIColor.mood_startColor().CGColor
        ]
        g.locations = [0.5, 1.0]
        g.frame = self.view.bounds
        return g
    }()
    
    lazy var gradientContainerView: UIView = {
        let view = UIView()
        view.alpha = 0.0
        view.frame = self.view.bounds
        view.layer.addSublayer(self.topBackgroundGradient)
        view.layer.addSublayer(self.bottomBackgroundGradient)
        return view
    }()
    
    @IBOutlet weak var cancelMoodView: ScaleDistanceView!
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)
        view.center = self.view.center
        view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.15)
        view.alpha = 0.0
        return view
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
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(gradientContainerView)
        view.addSubview(lineView)
        view.addSubview(cancelMoodView)
        
        moodCircle.delegate = self
        
        setup()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppearance {
            firstAppearance = false
            
            moodCircle.layer.shadowOpacity = 0.2
            moodCircle.layer.shadowOffset = CGSizeMake(0.0, 6.0)
            moodCircle.layer.shadowColor = UIColor.blackColor().CGColor
            moodCircle.layer.shadowRadius = 5.0
            moodCircle.backgroundColor = UIColor.mood_blueColor()
            
            // THIS CALL SETS THE ACCESS TOKEN FOR AUTHENTICATED
            // API REQUESTS
            if !Account.sharedAccount().isAuthenticated() {
                presentOnboarding()
            }
            
            
            _performBlock({ () -> Void in
                UIView.animateWithDuration(0.2, animations: {
                    self.view.alpha = 1.0
                })
            }, withDelay: 0.3)
            
        }
        
        updateLatestTimestamp();
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
            beginMood()
        case .Changed:
            let point = gesture.locationInView(view)
            moodCircle.center = point
            
            let xDist = fabs(view.center.x - point.x)
            let yDist = fabs(view.center.y - point.y)
            
            cancelMoodView.active = xDist < CancelMoodDistanceThreshold && yDist < CancelMoodDistanceThreshold
            
            moodCircle.backgroundColor = colorAtPoint(point)
        case .Ended:
            let point = gesture.locationInView(view)
            let size = view.frame.size
            let y: CGFloat = 1 - point.y / size.height
            
            currentMood = Int(trunc(y * 100))
            endMood()
        default:
            return
        }
    }
    
    private func beginMood() {
        capturingMood = true
        setNeedsStatusBarAppearanceUpdate()
        
        UIView.animateWithDuration(0.3, animations: {
            self.lineView.alpha = 1.0
            self.gradientContainerView.alpha = 1.0
            self.ratingHighImageView.alpha = 1.0
            self.ratingLowImageView.alpha = 1.0
            self.settingsButton.alpha = 0.0
            self.latestMoodLabel.alpha = 0.0
            self.view.backgroundColor = UIColor.mood_blueColor()
            self.cancelMoodView.alpha = 0.3
            self.moodCircle.alpha = 0.85
        })
    }
    
    private func endMood() {
        
        if moodEnding {
            return
        }
        
        capturingMood = false
        moodEnding = true
        
        let resetBlock: () -> Void = {
            self.moodEnding = false
            self.gradientContainerView.alpha = 0.0
            self.lineView.alpha = 0.0
            self.view.backgroundColor = UIColor.whiteColor()
            self.ratingHighImageView.alpha = 0.0
            self.settingsButton.alpha = 1.0
            self.ratingLowImageView.alpha = 0.0
            self.cancelMoodView.alpha = 0.0
            self.moodCircle.transform = CGAffineTransformIdentity;
            self.moodCircle.center = self.view.center
            self.moodCircle.alpha = 1.0
            self.moodCircle.backgroundColor = UIColor.mood_latestMoodColor()
            self.latestMoodLabel.alpha = 1.0
        }
        
        if !cancelMoodView.active {
            
            let height = view.frame.size.height
            let y = height - (height * (CGFloat(currentMood) / 100.0))
            transitionColor = colorAtPoint(CGPointMake(0, y))
            
            UIView.animateWithDuration(0.2, animations: {
                self.moodCircle.backgroundColor = self.transitionColor
                self.moodCircle.alpha = 1.0
                self.moodCircle.transform = CGAffineTransformMakeScale(15.0, 15.0)
            })
            
            _performBlock({
                self.performSegueWithIdentifier(MoodTransitions.ToJournal.rawValue, sender: self)
            }, withDelay: 0.4)
            
            _performBlock({ () -> Void in
                resetBlock()
            }, withDelay: 0.9 )
        } else {
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
                resetBlock()
            }, completion: { (_) -> Void in
                
            })
        }
        
        cancelMoodView.active = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func updateLatestTimestamp() {
        Account.currentUser().getLatestMood { (entry) -> Void in
            if let entry = entry {
                let lastMood = "Last mood\n"
                let timestamp = "\(entry.timestamp.relativeTimeToString())"
                var string = NSMutableAttributedString(string: "\(lastMood) \(timestamp)")
                let color = entry.color
                let range = NSMakeRange(count(lastMood), count(" \(timestamp)"))
                string.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
                self.latestMoodLabel.attributedText = string
                UIView.animateWithDuration(0.3, animations: {
                    self.moodCircle.backgroundColor = color
                    self.latestMoodLabel.alpha = 1.0
                })
            } else {
                self.latestMoodLabel.text = "Hold down to start recording your mood"
                self.latestMoodLabel.alpha = 1.0
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
            viewController.transitionColor = transitionColor
            viewController.mood = currentMood
            viewController.transitioningDelegate = self
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
    
    // MARK: UTILITY

    override func prefersStatusBarHidden() -> Bool {
        return capturingMood
    }

    override func shouldAutorotate() -> Bool {
        if let viewController = presentedViewController as? InfographViewController {
            return !viewController.orientationLocked
        } else if let viewController = presentedViewController as? NonRotatingNavigationController {
            return false
        } else if capturingMood {
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
    
    // MARK: <OnboardingViewControllerDelegate>
    
    func didFinishOnboarding(viewController: OnboardingViewController) {
        onMood = true
        dismissViewControllerAnimated(true, completion: nil)
    }
  
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
    
    func colorAtPoint(point: CGPoint) -> UIColor {
        var color = view.colorAtPoint(CGPointMake(0, point.y))
        if (transitionColor == UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) {
           color = self.view.colorAtPoint(CGPointMake(100, point.y))
        }
        return color
    }
    
    // MARK: <TouchableDelegate>
    
    func touchesBegan() {
        beginMood()
        cancelMoodView.active = true
        moodCircle.backgroundColor = colorAtPoint(view.center)
    }
    
    func touchesEnded() {
        endMood()
    }
    
}
