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
    @IBOutlet weak var ratingHighImageView: UIImageView!
    @IBOutlet weak var ratingLowImageView: UIImageView!
    
    // MARK: state
    
    private var firstAppearance = true
    private var onMood = true
    private var previousOrientation: UIDeviceOrientation = .Portrait
    
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
        view.frame = self.view.bounds
        view.layer.addSublayer(self.topBackgroundGradient)
        view.layer.addSublayer(self.bottomBackgroundGradient)
        return view
    }()
    
    lazy var cancelMoodView: ScaleDistanceView = {
        let view = ScaleDistanceView()
        view.layer.cornerRadius = 35.0
        view.frame = CGRectMake(0.0, 0.0, 70.0, 70.0)
        view.center = self.view.center
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
        return view
    }()
    
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
        view.backgroundColor = UIColor.mood_blueColor();
        
        view.addSubview(gradientContainerView)
        view.addSubview(lineView)
        view.addSubview(cancelMoodView)
        
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
            
            moodCircle.layer.shadowOpacity = 0.2
            moodCircle.layer.shadowOffset = CGSizeMake(0.0, 6.0)
            moodCircle.layer.shadowColor = UIColor.blackColor().CGColor
            moodCircle.layer.shadowRadius = 5.0
            
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
            beginMood()
        case .Changed:
            let translationPoint = gesture.translationInView(view)
            let actualPoint = gesture.locationInView(view)
            moodCircle.transform = CGAffineTransformMakeTranslation(translationPoint.x, translationPoint.y)
            
            let xDist = fabs(translationPoint.x)
            let yDist = fabs(translationPoint.y)
            
            cancelMoodView.active = xDist < 60 && yDist < 60
            
        case .Ended:
            let y: CGFloat = 1 - ((self.moodCircle.center.y + gesture.translationInView(view).y) / self.view.frame.size.height)
            currentMood = Int(trunc(y * 100))
            UIView.animateWithDuration(0.2, animations: {
                self.cancelMoodView.transform = CGAffineTransformIdentity
            })
        
            endMood()
        default:
            return
        }
>>>>>>> rip out old code add in new code
    }
    
    private func beginMood() {
        setNeedsStatusBarAppearanceUpdate()
        UIView.animateWithDuration(0.3, animations: {
            self.lineView.alpha = 1.0
            self.ratingHighImageView.alpha = 1.0
            self.ratingLowImageView.alpha = 1.0
            //            self.latestMoodLabel.alpha = 0.0
        })
    }
    
    private func endMood() {
        
        let scale = CGAffineTransformMakeScale(10.0, 10.0)
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.lineView.alpha = 0.0
            self.ratingHighImageView.alpha = 0.0
            self.ratingLowImageView.alpha = 0.0
            }, completion: { (_: Bool) -> Void in
        })
        
        if !cancelMoodView.active {
            self.performSegueWithIdentifier("MoodToJournalTransition", sender: self)
            _performBlock({ () -> Void in
                self.moodCircle.transform = CGAffineTransformIdentity;
                }, withDelay: 0.9 )
        } else {
            setNeedsStatusBarAppearanceUpdate()
            UIView.animateWithDuration(0.3, animations: {
                self.moodCircle.transform = CGAffineTransformIdentity;
            })

        }
        
        cancelMoodView.active = false
        
//        Analytics.track("mood", action: "set", label: "\(percentage)%")
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
            viewController.transitionColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: CGFloat(currentMood) / 100.0)
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
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
