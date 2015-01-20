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
import SpriteKit

protocol MoodViewControllerDelegate {
    func didBeginNewMood()
    func didEndNewMood()
}

enum MoodPhase: String {
    case Terrible = "Terrible"
    case Meh = "Meh"
    case PrettyGood = "Pretty Good"
    case Great = "Great"
}

class MoodViewController: UIViewController, MoodViewDelegate {
    
    
    // ------------------------- \\
    // MARK: INSTANCE VARIABLES
    // ------------------------- \\

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moodTrigger: MoodView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    // MARK: constants (kinda)
    
    private var multiplier: CFTimeInterval = 1.0
    private let animationDuration: CFTimeInterval = 20.0
    private let animationSpeed: CFTimeInterval = 0.1
    
    private let spaceBetweenTouchPointAndMoodCircle: CGFloat = 6.0
    
    private let startColor = UIColor.mood_startColor()
    private let endColor = UIColor.mood_endColor()
    
    private var numberOfMoods = 4
    
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
    
    private lazy var effect: SKEmitterNode? = {
        let path = NSBundle.mainBundle().pathForResource("magic", ofType: "sks")
        if let p = path {
            let node: SKEmitterNode? = NSKeyedUnarchiver.unarchiveObjectWithFile(p) as? SKEmitterNode
            node?.particleColorSequence = nil
            return node
        }
        return nil
    }()
    
    // MARK: constants - particle simulation
    
    private let sceneView: SKView = SKView()
    
    private let particleStartColor = UIColor.particle_startColor()
    private let particleEndColor = UIColor.particle_endColor()
    
    private let startBirthrate: CGFloat = 47.6
    private let endBirthrate: CGFloat = 400.0
    private let startLifetime: CGFloat = 0.5
    private let endLifetime: CGFloat = 0.7
    private let startLifetimeRange: CGFloat = 0.0
    private let endLifetimeRange: CGFloat = 0.7
    private let startPosition = CGPoint(x: 0, y: 0)
    private let endPosition = CGPoint(x: 300, y: 430)
    private let startSpeed: CGFloat = 0.0
    private let endSpeed: CGFloat = 20.0
    private let startSpeedRange: CGFloat = 200.0
    private let endSpeedRange: CGFloat = 600.0

    // MARK: state
    
    private var currentTime: CFTimeInterval = 0.0
    private var firstAppearance = true
    private var isSetup = false
    
    private var circle = CAShapeLayer()
    private var touchPoint = CAShapeLayer()
    private var timer: NSTimer?
    
    var delegate: MoodViewControllerDelegate?

    
    // ------------------------- \\
    // MARK: LIFE CYCLE
    // ------------------------- \\
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moodTrigger.delegate = self
        
        setup()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if firstAppearance {
            firstAppearance = false
            
            createAndAddTouchPoint()
            createAndAddMoodCircle()
            setupParticleEffect()
            
            createNewMood()

            isSetup = true
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // ------------------------- \\
    // MARK: SETUP
    // ------------------------- \\
    
    
    // MARK: viewcontroller
    
    private func setup() {
        view.backgroundColor = UIColor.mood_blueColor()
        contentView.transform = CGAffineTransformMakeScale(0.6, 0.6)
        contentView.alpha = 0.4
        
        setupObservers()
    }
    
    private func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterForeground", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    private func setupParticleEffect() {
        sceneView.frame = view.bounds
        sceneView.alpha = 0.0
        sceneView.allowsTransparency = true
        sceneView.backgroundColor = UIColor.clearColor()
        
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = UIColor.clearColor()
        
        if let e = effect {
            scene.addChild(e)
            e.position = CGPoint(x: view.frame.size.width / 2.0, y: contentView.center.y)
            e.particleColor = UIColor.particle_startColor()
        }
        
        sceneView.presentScene(scene)
        view.insertSubview(sceneView, belowSubview: containerView)
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
    
    
    // ------------------------- \\
    // MARK: NOTIFICATIONS
    // ------------------------- \\
    
    
    func applicationDidEnterForeground() {
        if isSetup {
            addGrowAnimation()
        }
    }

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
        morph.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        morph.fromValue = circle.path
        morph.toValue   = UIBezierPath(roundedRect: finalRect, cornerRadius: finalRadius).CGPath
        circle.addAnimation(morph, forKey: "path")

        circle.speed = 0.0;
    }

    func update() {
        currentTime += animationSpeed * multiplier

        if currentTime <= 0.0 || currentTime >= animationDuration {
            currentTime = currentTime <= 0.0 ? 0.0 : animationDuration
            multiplier *= -1
        }
        
        circle.timeOffset = currentTime

        let perc: CGFloat = CGFloat(currentTime / animationDuration)
        
        view.backgroundColor = colorAtPercentage(startColor, color2: endColor, percentage: perc)
        moodLabel.text = moodStringForAnimationPercentage(perc)
        updateParticleSimulation(perc)
    }
    
    private func updateParticleSimulation(percentage: CGFloat) {
        var birthrate = valueForPercentage(startBirthrate, num2: endBirthrate, perc: percentage)
        var lifetime = valueForPercentage(startLifetime, num2: endLifetime, perc: percentage)
        var lifetimeRange = valueForPercentage(startLifetimeRange, num2: endLifetimeRange, perc: percentage)
        var positionRangeX = valueForPercentage(startPosition.x, num2: endPosition.x, perc: percentage)
        var positionRangeY = valueForPercentage(startPosition.y, num2: endPosition.y, perc: percentage)
        var positionRange = CGPoint(x: positionRangeX, y: positionRangeY)
        var speed = valueForPercentage(startSpeed, num2: endSpeed, perc: percentage)
        var speedRange = valueForPercentage(startSpeedRange, num2: endSpeedRange, perc: percentage)
        
        effect?.particleBirthRate = birthrate
        effect?.particleLifetime = lifetime
        effect?.particleLifetimeRange = lifetimeRange
        effect?.particlePositionRange = CGVector(dx: positionRange.x, dy: positionRange.y)
        effect?.particleSpeed = speed
        effect?.particleSpeedRange = speedRange
        effect?.particleColor = colorAtPercentage(particleStartColor, color2: particleEndColor, percentage: percentage)
    }
    
    
    // ------------------------- \\
    // MARK: UTILITY
    // ------------------------- \\
    
    
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

    private func colorAtPercentage(color1: UIColor, color2: UIColor, percentage: CGFloat) -> UIColor {
        let firstComponents = CGColorGetComponents(color1.CGColor)
        let secondComponents = CGColorGetComponents(color2.CGColor)

        let newRed = valueForPercentage(firstComponents[0], num2: secondComponents[0], perc: percentage)
        let newGreen = valueForPercentage(firstComponents[1], num2: secondComponents[1], perc: percentage)
        let newBlue = valueForPercentage(firstComponents[2], num2: secondComponents[2], perc: percentage)

        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }

    private func valueForPercentage(num: CGFloat, num2: CGFloat, perc: CGFloat) -> CGFloat {
        let floor = min(num, num2)
        let ceil = max(num, num2)
        let val = (ceil - floor) * perc
        return num > num2 ? ceil - val : floor + val
    }
    
    
    // ------------------------- \\
    // MARK: <MoodViewDelegate>
    // ------------------------- \\

    
    func moodViewTouchesBegan() {
        
        UIView.animateWithDuration(1.0, animations: {
            self.sceneView.alpha = 1.0
            return()
        })

        delegate?.didBeginNewMood()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1 / 60, target: self, selector: "update", userInfo: nil, repeats: true)

        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.touchPoint.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
            self.touchPoint.opacity = 0.5
            }) { (done: Bool) -> Void in
                return()
        }
        
//        UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: {
//            self.moodLabel.alpha = 1.0
//            }) { (done: Bool) -> Void in
//                return()
//        }
    }

    func moodViewTouchesEnded() {
        
        delegate?.didEndNewMood()
        
        timer?.invalidate()

        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.touchPoint.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            self.touchPoint.opacity = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
        
//        UIView.animateWithDuration(0.2, animations: {
//            self.moodLabel.alpha = 0.0
//        })
        
        UIView.animateWithDuration(0.6, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.contentView.transform = CGAffineTransformConcat(self.contentView.transform, CGAffineTransformMakeScale(0.1, 0.1))
            self.contentView.alpha = 0.8
            }) { (done: Bool) -> Void in
                self.circle.timeOffset = 0.0
                self.currentTime = 0.0
                self.createNewMood()

                let center = self.containerView.frame.origin.y + self.contentView.frame.origin.y + 40

                return()
        }

        UIView.animateWithDuration(1.0, animations: {
            self.view.backgroundColor = UIColor.mood_blueColor()
        })
        
        // cleanup particle simulation
        
        UIView.animateWithDuration(2.0, animations: {
            self.sceneView.alpha = 0.0
            return()
            }) { (done: Bool) -> Void in
                self.effect?.particleBirthRate = self.startBirthrate
                self.effect?.particleLifetime = self.startLifetime
                self.effect?.particleLifetimeRange = self.startLifetimeRange
                self.effect?.particlePositionRange = CGVector(dx: self.startPosition.x, dy: self.startPosition.y)
                self.effect?.particleSpeed = self.startSpeed
                self.effect?.particleSpeedRange = self.startSpeedRange
                return()
        }
    }

}
