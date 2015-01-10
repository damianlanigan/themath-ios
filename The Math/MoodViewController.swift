//
//  MoodViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

enum MoodPhase: String {
    case Default = ""
    case Terrible = "Terrible"
    case Meh = "Meh"
    case PrettyGood = "Pretty Good"
    case Great = "Great"
}

class MoodViewController: UIViewController, MoodViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moodTrigger: MoodView!
    
    let AnimationKey = "MoodAnimation"
    
    let circle = CAShapeLayer()
    let touchPoint = CAShapeLayer()
    var timer: NSTimer?
    var currentTime: CFTimeInterval = 0.0
    var multiplier: CFTimeInterval = 1.0
    
    let animationDuration: CFTimeInterval = 20.0
    let initialRadius: CGFloat = 40.0
    let animationSpeed: CFTimeInterval = 0.3
    
    let startColor = UIColor.mood_startColor()
    let endColor = UIColor.mood_endColor()
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moodTrigger.delegate = self
        
        view.backgroundColor = UIColor.mood_blueColor()
        
        createAndAddTouchPoint()
        createAndAddMoodCircle()
        
        contentView.transform = CGAffineTransformMakeScale(0.6, 0.6)
        contentView.alpha = 0.0
        
        UIView.animateWithDuration(1.4, delay: 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.contentView.alpha = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
        
    }
    
    func createNewMood() {
        
        currentTime = 0.0
        circle.timeOffset = 0.0
        
        let radius: CGFloat = 40.0
        let rect: CGRect = CGRect(x: 0, y: 0, width: radius * 2.0, height: radius * 2.0)
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.25
        animation.fromValue = circle.presentationLayer().path
        animation.toValue = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
        animation.delegate = self
        
        circle.speed = 1.0
        circle.addAnimation(animation, forKey: AnimationKey)
        
        circle.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
        
        let aTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "addGrowAnimation", userInfo: nil, repeats: false)
    }
    
    private func createAndAddTouchPoint() {
        let touchRadius: CGFloat = initialRadius - 4.0
        let touchRect: CGRect = CGRect(x: 0, y: 0, width: touchRadius * 2.0, height: touchRadius * 2.0)

        touchPoint.rasterizationScale = UIScreen.mainScreen().scale
        touchPoint.shouldRasterize = true
        touchPoint.frame = CGRect(x: 0, y: 0, width: touchRadius * 2.0, height: touchRadius * 2.0)
        touchPoint.position = CGPoint(x: view.center.x, y: view.center.x)
        touchPoint.path = UIBezierPath(roundedRect: touchRect, cornerRadius: touchRadius).CGPath
        touchPoint.fillColor = UIColor.whiteColor().colorWithAlphaComponent(1.0).CGColor
        
        contentView.layer.addSublayer(touchPoint)
    }
    
    private func createAndAddMoodCircle() {
        let radius: CGFloat = initialRadius
        let rect: CGRect = CGRect(x: 0, y: 0, width: radius * 2.0, height: radius * 2.0)
        circle.rasterizationScale = UIScreen.mainScreen().scale
        circle.shouldRasterize = true
        circle.frame = CGRect(x: 0, y: 0, width: radius * 2.0, height: radius * 2.0)
        circle.position = CGPoint(x: view.center.x, y: view.center.x)
        circle.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
        circle.fillColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
        circle.strokeColor = UIColor.whiteColor().colorWithAlphaComponent(0.8).CGColor
        circle.lineWidth = 2.0
        
        contentView.layer.addSublayer(circle)
        
        addGrowAnimation()
    }
    
    func addGrowAnimation() {
        
        circle.removeAllAnimations()
        
        let morph: CABasicAnimation = CABasicAnimation(keyPath: "path")
        morph.duration = animationDuration
        morph.fromValue = circle.path
        morph.toValue   = toPath()
        circle.addAnimation(morph, forKey: AnimationKey)
        
        circle.speed = 0.0;
    }
    
    func update() {
        currentTime += animationSpeed * multiplier
        circle.timeOffset = currentTime
        
        let perc: CGFloat = CGFloat(currentTime / animationDuration)
        let currentColor = colorAtPercentage(startColor, color2: endColor, perc: perc)

        if circle.timeOffset <= 0.0 || circle.timeOffset >= animationDuration {
            let newValue = circle.timeOffset <= 0.0 ? 0.0 : animationDuration
            currentTime = newValue
            circle.timeOffset = newValue
            multiplier *= -1
        }
        
        view.backgroundColor = currentColor
    }
    
    func cleanup() {
        let radius: CGFloat = 20.0
        let rect: CGRect = CGRect(x: 20, y: 20, width: radius * 2.0, height: radius * 2.0)
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.20
        animation.fromValue = circle.presentationLayer().path
        animation.toValue = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
        animation.delegate = self
        
        circle.speed = 1.0
        circle.addAnimation(animation, forKey: AnimationKey)
        
        circle.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
        
        UIView.animateWithDuration(1.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.view.backgroundColor = UIColor.mood_blueColor()
            }) { (done: Bool) -> Void in
                return()
        }
        
        let aTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "createNewMood", userInfo: nil, repeats: false)
    }
    
    private func toPath() -> CGPath {
        let gutter: CGFloat = 14.0
        let radius: CGFloat = view.frame.size.width / 2.0 - gutter
        let x: CGFloat = -(view.frame.size.width / 2.0 - (initialRadius + gutter))
        let finalOrigin = CGPoint(x: x, y: x)
        let rect: CGRect = CGRect(x: finalOrigin.x, y: finalOrigin.y, width: radius * 2.0, height: radius * 2.0)
        return UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
    }
    
    private func colorAtPercentage(color1: UIColor, color2: UIColor, perc: CGFloat) -> UIColor {
        let firstComp = CGColorGetComponents(color1.CGColor)
        let secondComp = CGColorGetComponents(color2.CGColor)
        
        let red1 = firstComp[0]
        let red2 = secondComp[0]
        let newRed = numbers(red1, num2: red1, perc: perc)

        let green1 = firstComp[1]
        let green2 = secondComp[1]
        let newGreen = numbers(green1, num2: green2, perc: perc)
        
        let blue1 = firstComp[2]
        let blue2 = secondComp[2]
        let newBlue = numbers(blue1, num2: blue2, perc: perc)

        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    private func numbers(num: CGFloat, num2: CGFloat, perc: CGFloat) -> CGFloat {
        let floor = min(num, num2)
        let ceil = max(num, num2)
        let val = (ceil - floor) * perc
        return num > num2 ? ceil - val : floor + val
    }
    
    
    // MARK: MoodViewDelegate
    
    func moodViewTouchesBegan() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1 / 60, target: self, selector: "update", userInfo: nil, repeats: true)
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.touchPoint.opacity = 0.5
            self.touchPoint.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
            }) { (done: Bool) -> Void in
                return()
        }
    }
    
    func moodViewTouchesEnded() {
        timer?.invalidate()
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.touchPoint.opacity = 1.0
            self.touchPoint.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            }) { (done: Bool) -> Void in
                return()
        }
        
        let aTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "cleanup", userInfo: nil, repeats: false)
    }
    
}
