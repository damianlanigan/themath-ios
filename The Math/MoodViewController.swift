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
import AMPopTip

class MoodViewController: UIViewController,
    MoodViewDelegate,
    OnboardingViewControllerDelegate,
    SettingsTableViewControllerDelegate,
    UIAlertViewDelegate,
    MFMailComposeViewControllerDelegate,
    UINavigationControllerDelegate,
    UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var moodReferenceView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moodTrigger: MoodView!
    @IBOutlet weak var initialCircle: UIView!
    
    var circle = CAShapeLayer()
    private var touchPoint = CAShapeLayer()
    private var timer: NSTimer?
    private var currentMood = 0
    
    var transitionColor: UIColor?
    
    // MARK: constants
    
    private var multiplier: CFTimeInterval = 1.0
    private let animationDuration: CFTimeInterval = 28.0
    private let animationSpeed: CFTimeInterval = 0.15
    private let panMinDistanceThreshold = 10.0
    
    private let gutter: CGFloat = 0.0
    private let initialRadius: CGFloat = 36.0
    private lazy var initialRect: CGRect = {
        return CGRect(x: 0, y: 0, width: self.initialRadius * 2.0, height: self.initialRadius * 2.0)
    }()
    private lazy var finalRadius: CGFloat = {
        return self.view.frame.size.height / 2.0 - self.gutter
    }()
    private lazy var finalRect: CGRect = {
        let x: CGFloat = -(self.view.frame.size.height / 2.0 - (self.initialRadius + self.gutter))
        let finalOrigin = CGPoint(x: x, y: x)
        return CGRect(x: finalOrigin.x, y: finalOrigin.y, width: self.finalRadius * 2.0, height: self.finalRadius * 2.0)
    }()

    // MARK: state
    
    private var capturingMood = false
    private var currentTime: CFTimeInterval = 0.0
    private var firstAppearance = true
    private var isSetup = false
    private var onMood = true
    private var isPanning = false
    private var previousOrientation: UIDeviceOrientation = .Portrait

    
    lazy var toolTip: AMPopTip = {
        var tip = AMPopTip()
        tip.shouldDismissOnTap = true
        tip.edgeMargin = 10.0
        tip.offset = 12
        tip.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        tip.textAlignment = .Center
        tip.popoverColor = UIColor(red: 228/255.0, green: 238/255.0, blue: 251/255.0, alpha: 1.0)
        return tip
    }()
    
    lazy var infographViewController: InfographViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("Infograph") as? InfographViewController
        return viewController!
    }()
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: LIFE CYCLE

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.0
        moodTrigger.delegate = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "panning:")
        moodTrigger.addGestureRecognizer(panGesture)
        
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstAppearance {
            createAndAddMoodCircle()
            createAndAddTouchPoint()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppearance {
            firstAppearance = false
            createNewMood()
            isSetup = true
            showTooltip()
            
            // THIS CALL SETS THE ACCESS TOKEN FOR AUTHENTICATED
            // API REQUESTS
            if !Account.sharedAccount().isAuthenticated() {
//                presentOnboarding()
            }
            
            _performBlock({ () -> Void in
                UIView.animateWithDuration(0.2, animations: {
                    self.view.alpha = 1.0
                })
            }, withDelay: 0.2)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: SETUP
    
    
    // MARK: viewcontroller
    
    private func setup() {
        setupObservers()
    }
    
    private func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterForeground", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    private func showTooltip() {
        AMPopTip.appearance().textColor = UIColor.blackColor()
        AMPopTip.appearance().textAlignment = .Center
        
        var titleString = NSMutableAttributedString(string: "Hold Down")
        var bodyString = NSMutableAttributedString(string: "\nThe better you're feeling the longer you hold.")
        
        let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 16)!
        let bodyFont = UIFont(name: "AvenirNext-Medium", size: 16)!
        let titleRange = NSMakeRange(0, 9)
        let bodyRange = NSMakeRange(0, count(bodyString.string))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        titleString.addAttributes([
            NSFontAttributeName : titleFont,
            NSParagraphStyleAttributeName : paragraphStyle
        ], range: titleRange)
        
        bodyString.addAttributes([
            NSFontAttributeName : bodyFont,
            NSParagraphStyleAttributeName : paragraphStyle
        ], range: bodyRange)
        
        titleString.appendAttributedString(bodyString)

        toolTip.showAttributedText(titleString, direction: .Up, maxWidth: 200, inView: contentView, fromFrame: moodTrigger.frame)
    }

    // MARK: mood 
    
    private func createAndAddTouchPoint() {
        let touchRadius: CGFloat = initialRadius
        let touchRect: CGRect = CGRect(x: 0, y: 0, width: touchRadius * 2.0, height: touchRadius * 2.0)
        touchPoint.rasterizationScale = UIScreen.mainScreen().scale
        touchPoint.shouldRasterize = true
        touchPoint.frame = CGRect(x: 0, y: 0, width: touchRadius * 2.0, height: touchRadius * 2.0)
        
        touchPoint.position = CGPoint(x: view.center.x, y: view.center.y)
        touchPoint.path = UIBezierPath(roundedRect: touchRect, cornerRadius: touchRadius).CGPath
        touchPoint.fillColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
        touchPoint.opacity = 0.0
        
        view.layer.addSublayer(touchPoint)
    }
    
    private func createAndAddMoodCircle() {
        circle.rasterizationScale = UIScreen.mainScreen().scale
        circle.shouldRasterize = true
        circle.frame = CGRect(x: 0, y: 0, width: initialRadius * 2.0, height: initialRadius * 2.0)
        circle.position = CGPoint(x: moodTrigger.frame.size.width / 2.0, y: moodTrigger.frame.size.width / 2.0)
        circle.path = UIBezierPath(roundedRect: initialRect, cornerRadius: initialRadius).CGPath
        
        moodTrigger.layer.addSublayer(circle)
        
        initialCircle.backgroundColor = UIColor.mood_initialColor()
        initialCircle.layer.cornerRadius = initialRadius
        
        addGrowAnimationToLayer(circle)
        addColorAnimationToLayer(circle)
    }
    
    func panning(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            if (abs(gesture.translationInView(view).x) > 25) || (abs(gesture.translationInView(view).y) > 25) || isPanning {
                isPanning = true
                timer?.invalidate()
                let location = gesture.locationInView(view)
                var x = abs(view.center.x - location.x)
                var y = abs(view.center.y - location.y)
                let distance = sqrt(pow(x, 2)) + sqrt(pow(y, 2))
                currentTime = NSTimeInterval(distance / view.center.y) * animationDuration
                update()
            }
        case .Ended:
            if capturingMood {
                endMood()
            }
        default:
            return
        }
    }
    
    // MARK: IBACTION
    
    @IBAction func replayOnboardingButtonTapped(sender: UIButton) {
        toolTip.hide()
        let alert = UIAlertView(title: "Settings", message: "", delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles: "Replay tutorial", "Send feedback")
        alert.show()
    }
    
    // MARK: NOTIFICATIONS
    
    func applicationDidEnterForeground() {
        if isSetup {
            addGrowAnimationToLayer(circle)
            addColorAnimationToLayer(circle)
        }
    }
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    private func createNewMood() {
        UIView.animateWithDuration(0.4, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.circle.timeOffset = 0.0
            self.currentTime = 0
            self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.contentView.alpha = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
    }

    func addGrowAnimationToLayer(layer: CAShapeLayer) {
        let morph: CABasicAnimation = CABasicAnimation(keyPath: "path")
        morph.duration = animationDuration
        morph.fromValue = layer.path
        morph.toValue   = toPath()
        layer.addAnimation(morph, forKey: "path")
        layer.speed = 0.0;
    }
    
    func addColorAnimationToLayer(layer: CAShapeLayer) {
        let colorAnim = CAKeyframeAnimation(keyPath:"fillColor")
        let colors = UIColor.mood_gradientColors()
        colorAnim.values = colors
        colorAnim.calculationMode = kCAAnimationPaced
        colorAnim.duration = animationDuration
        layer.speed = 0.0
        layer.addAnimation(colorAnim, forKey: "fillColor")        
    }

    func update() {
        currentTime += animationSpeed * multiplier
        circle.timeOffset = currentTime

        if circle.timeOffset <= 0.0 || circle.timeOffset >= animationDuration {
            let newValue = circle.timeOffset <= 0.0 ? 0.0 : animationDuration
            currentTime = newValue
            circle.timeOffset = newValue
            multiplier *= -1
        }
    }
    
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
            let color = circle.presentationLayer().valueForKeyPath("fillColor") as! CGColor
            viewController.transitionColor = UIColor(CGColor: color)
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


    private func toPath() -> CGPath {
        return UIBezierPath(roundedRect: finalRect, cornerRadius: finalRadius).CGPath
    }
    
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
        return true
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
        toolTip.hide()
        timer = NSTimer.scheduledTimerWithTimeInterval(1 / 60, target: self, selector: "update", userInfo: nil, repeats: true)
        
        moodReferenceView.transform = CGAffineTransformMakeScale(0.95, 0.95)
        UIView.animateWithDuration(0.3, animations: {
            self.moodReferenceView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.initialCircle.alpha = 0.0
        })
        UIView.animateWithDuration(0.8, animations: {
            self.touchPoint.opacity = 0.3
            self.moodReferenceView.alpha = 1.0
            
            self.settingsButton.alpha = 0.0
        })
    }
    
    private func endMood() {
        capturingMood = false
        isPanning = false
        
        // for API
        let percentage = trunc(currentTime / animationDuration * 100)
        println("Mood: \(percentage)%")
        
        currentMood = Int(percentage)
        
        timer?.invalidate()
        
        UIView.animateWithDuration(0.2, animations: {
            self.touchPoint.opacity = 0.0
            self.moodReferenceView.alpha = 0.0
        })
        
        self.performSegueWithIdentifier("MoodToJournalTransition", sender: self)

        _performBlock({ () -> Void in
            self.createNewMood()
            self.setNeedsStatusBarAppearanceUpdate()
            self.settingsButton.alpha = 1.0
            self.initialCircle.alpha = 1.0
        }, withDelay: 0.9 )
        
        Analytics.track("mood", action: "set", label: "\(percentage)%")
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
