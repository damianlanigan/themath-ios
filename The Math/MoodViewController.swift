//
//  👨
//
//  MoodViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol MoodViewControllerDelegate {
    func didBeginNewMood()
    func didEndNewMood()
    
    // temp
    func shouldReplayOnboarding()
}

class MoodViewController: GAITrackedViewController,
    MoodViewDelegate,
    UIViewControllerTransitioningDelegate {
    
    
    // MARK: INSTANCE VARIABLES


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moodTrigger: MoodView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var transitionColor: UIColor?
    
    // MARK: constants
    
    private var multiplier: CFTimeInterval = 1.0
    private let animationDuration: CFTimeInterval = 20.0
    private let animationSpeed: CFTimeInterval = 0.15
    
    private let spaceBetweenTouchPointAndMoodCircle: CGFloat = 6.0
    
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
    
    private var currentTime: CFTimeInterval = 0.0
    private var firstAppearance = true
    private var isSetup = false
    
    var circle = CAShapeLayer()
    private var touchPoint = CAShapeLayer()
    private var timer: NSTimer?
    
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
    
    var delegate: MoodViewControllerDelegate?
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: LIFE CYCLE

    
    override func viewDidLoad() {
        super.viewDidLoad()

        moodTrigger.delegate = self
        
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Mood"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if firstAppearance {
            firstAppearance = false
            createAndAddTouchPoint()
            createAndAddMoodCircle()

            contentView.transform = CGAffineTransformMakeScale(0.6, 0.6)
            contentView.alpha = 0.4

            createNewMood()

            isSetup = true
            
            showTooltip()
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
        let touchRadius: CGFloat = initialRadius - spaceBetweenTouchPointAndMoodCircle
        let touchRect: CGRect = CGRect(x: 0, y: 0, width: touchRadius * 2.0, height: touchRadius * 2.0)
        touchPoint.rasterizationScale = UIScreen.mainScreen().scale
        touchPoint.shouldRasterize = true
        touchPoint.frame = CGRect(x: 0, y: 0, width: touchRadius * 2.0, height: touchRadius * 2.0)
        
        touchPoint.position = CGPoint(x: view.center.x, y: containerView.frame.origin.y + contentView.center.y)
        touchPoint.path = UIBezierPath(roundedRect: touchRect, cornerRadius: touchRadius).CGPath
        touchPoint.fillColor = UIColor.clearColor().CGColor
        
        view.layer.addSublayer(touchPoint)
    }
    
    private func createAndAddMoodCircle() {
        circle.rasterizationScale = UIScreen.mainScreen().scale
        circle.shouldRasterize = true
        circle.frame = CGRect(x: 0, y: 0, width: initialRadius * 2.0, height: initialRadius * 2.0)
        circle.position = CGPoint(x: view.center.x, y: view.center.x)
        circle.path = UIBezierPath(roundedRect: initialRect, cornerRadius: initialRadius).CGPath
//        circle.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.2).CGColor
        
        contentView.layer.addSublayer(circle)
        
        addGrowAnimation()
        addColorAnimation()
    }
    
    // MARK: IBACTION
    
    @IBAction func replayOnboardingButtonTapped(sender: UIButton) {
        toolTip.hide()
        delegate?.shouldReplayOnboarding()
    }
    
    // MARK: NOTIFICATIONS
    
    func applicationDidEnterForeground() {
        if isSetup {
            addGrowAnimation()
            addColorAnimation()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? JournalViewController {
            let color = circle.presentationLayer().valueForKeyPath("fillColor") as! CGColor
            viewController.transitionColor = UIColor(CGColor: color)
            viewController.transitioningDelegate = self
            viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
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

    func addGrowAnimation() {
        let morph: CABasicAnimation = CABasicAnimation(keyPath: "path")
        morph.duration = animationDuration
        morph.fromValue = circle.path
        morph.toValue   = toPath()
        circle.addAnimation(morph, forKey: "path")

        circle.speed = 0.0;
    }
    
    func addColorAnimation() {
        let color: CABasicAnimation = CABasicAnimation(keyPath: "fillColor")
        color.duration = animationDuration
        color.fromValue = UIColor.mood_startColor().CGColor
        color.toValue   = UIColor.mood_endColor().CGColor
        circle.addAnimation(color, forKey: "fillColor")
        
        circle.speed = 0.0;
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
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: UTILITY


    private func toPath() -> CGPath {
        return UIBezierPath(roundedRect: finalRect, cornerRadius: finalRadius).CGPath
    }
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: <MoodViewDelegate>


    func moodViewTouchesBegan() {
        
        toolTip.hide()
        
        delegate?.didBeginNewMood()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1 / 60, target: self, selector: "update", userInfo: nil, repeats: true)

        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.touchPoint.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
            self.touchPoint.opacity = 0.5
            }) { (done: Bool) -> Void in
                return()
        }
        
    }

    func moodViewTouchesEnded() {
        
        // for API
        let percentage = trunc(currentTime / animationDuration * 100)
        println("Mood: \(percentage)%")
        
        Tracker.track("mood", action: "set", label: "\(percentage)%")
        
        delegate?.didEndNewMood()
        
        timer?.invalidate()

        println(circle.timeOffset / animationDuration)
        performSegueWithIdentifier("MoodToJournalTransition", sender: self)
        
        let delay = 0.7 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.createNewMood()
        })
    }
    
    // TEMPORARY
    
    func tooltipForConfirmation() {
        var tip = AMPopTip()
        tip.shouldDismissOnTap = true
        tip.edgeMargin = 10.0
        tip.offset = 12
        tip.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        tip.textAlignment = .Center
        tip.popoverColor = UIColor(red: 228/255.0, green: 238/255.0, blue: 251/255.0, alpha: 1.0)
        var titleString = NSMutableAttributedString(string: "Mood saved")
        
        let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 16)!
        let titleRange = NSMakeRange(0, count("Mood saved"))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        titleString.addAttributes([
            NSFontAttributeName : titleFont,
            NSParagraphStyleAttributeName : paragraphStyle
            ], range: titleRange)
    
        toolTip = tip
        toolTip.showAttributedText(titleString, direction: .Up, maxWidth: 200, inView: contentView, fromFrame: moodTrigger.frame, duration: 2.0)
    }
    
    // MARK: <UIViewControllerTransitioningDelegate>
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MaskAnimationController()
        animator.presenting = true
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAnimationController()
    }
}
