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

class MoodViewController: GAITrackedViewController, MoodViewDelegate {
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: INSTANCE VARIABLES


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moodTrigger: MoodView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    // MARK: constants
    
    private var multiplier: CFTimeInterval = 1.0
    private let animationDuration: CFTimeInterval = 20.0
    private let animationSpeed: CFTimeInterval = 0.15
    
    private let spaceBetweenTouchPointAndMoodCircle: CGFloat = 6.0
    
    private let gutter: CGFloat = 14.0
    private let initialRadius: CGFloat = 36.0
    private lazy var initialRect: CGRect = {
        return CGRect(x: 0, y: 0, width: self.initialRadius * 2.0, height: self.initialRadius * 2.0)
    }()
    private lazy var finalRadius: CGFloat = {
        return self.view.frame.size.width / 2.0 - self.gutter
    }()
    private lazy var finalRect: CGRect = {
        let x: CGFloat = -(self.view.frame.size.width / 2.0 - (self.initialRadius + self.gutter))
        let finalOrigin = CGPoint(x: x, y: x)
        return CGRect(x: finalOrigin.x, y: finalOrigin.y, width: self.finalRadius * 2.0, height: self.finalRadius * 2.0)
    }()

    // MARK: state
    
    private var currentTime: CFTimeInterval = 0.0
    private var firstAppearance = true
    private var isSetup = false
    
    private var circle = CAShapeLayer()
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
        view.backgroundColor = UIColor.mood_blueColor()
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
        let bodyRange = NSMakeRange(0, countElements(bodyString.string))
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
        touchPoint.fillColor = UIColor.whiteColor().colorWithAlphaComponent(1.0).CGColor
        
        view.layer.addSublayer(touchPoint)
    }
    
    private func createAndAddMoodCircle() {
        circle.rasterizationScale = UIScreen.mainScreen().scale
        circle.shouldRasterize = true
        circle.frame = CGRect(x: 0, y: 0, width: initialRadius * 2.0, height: initialRadius * 2.0)
        circle.position = CGPoint(x: view.center.x, y: view.center.x)
        circle.path = UIBezierPath(roundedRect: initialRect, cornerRadius: initialRadius).CGPath
        circle.fillColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
        circle.strokeColor = UIColor.whiteColor().colorWithAlphaComponent(0.8).CGColor
        circle.lineWidth = 3.0
        
        contentView.layer.addSublayer(circle)
        
        addGrowAnimation()
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
        }
    }

    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    
    private func createNewMood() {
        UIView.animateWithDuration(1.4, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
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

    func update() {
        currentTime += animationSpeed * multiplier
        circle.timeOffset = currentTime

        if circle.timeOffset <= 0.0 || circle.timeOffset >= animationDuration {
            let newValue = circle.timeOffset <= 0.0 ? 0.0 : animationDuration
            currentTime = newValue
            circle.timeOffset = newValue
            multiplier *= -1
        }

        let perc: CGFloat = CGFloat(currentTime / animationDuration)
        let currentColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
        view.backgroundColor = currentColor
        
        moodLabel.text = moodStringForAnimationPercentage(perc)
    }
    
    
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    
    // MARK: UTILITY

    
    private func moodStringForAnimationPercentage(percentage: CGFloat) -> String {
        let perc = percentage * 100
        switch perc {
        case 0...30:
            return "Terrible"
        case 30.1...55:
            return "Meh"
        case 55.1...80:
            return "Pretty Good"
        case 80.1...100:
            return "Great"
        default:
            return "Meh"
        }
    }

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
        
        UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.moodLabel.alpha = 1.0
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

        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.touchPoint.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            self.touchPoint.opacity = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.moodLabel.alpha = 0.0
        })
        
        UIView.animateWithDuration(0.6, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.contentView.transform = CGAffineTransformConcat(self.contentView.transform, CGAffineTransformMakeScale(0.1, 0.1))
            self.contentView.alpha = 0.8
            }) { (done: Bool) -> Void in
                self.circle.timeOffset = 0.0
                self.currentTime = 0.0
                self.createNewMood()

                let center = self.containerView.frame.origin.y + self.contentView.frame.origin.y + 40

//                self.tooltipForConfirmation()
                
                return()
        }

        UIView.animateWithDuration(1.0, animations: {
            self.view.backgroundColor = UIColor.mood_blueColor()
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
        let titleRange = NSMakeRange(0, countElements("Mood saved"))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        titleString.addAttributes([
            NSFontAttributeName : titleFont,
            NSParagraphStyleAttributeName : paragraphStyle
            ], range: titleRange)
    
        toolTip = tip
        toolTip.showAttributedText(titleString, direction: .Up, maxWidth: 200, inView: contentView, fromFrame: moodTrigger.frame, duration: 2.0)
    }
}
