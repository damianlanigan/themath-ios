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

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moodTrigger: MoodView!
    
    var circle = CAShapeLayer()
    var touchPoint = CAShapeLayer()
    var timer: NSTimer?
    var currentTime: CFTimeInterval = 0.0
    var multiplier: CFTimeInterval = 1.0
    
    let animationDuration: CFTimeInterval = 20.0
    let initialRadius: CGFloat = 46.0
    let animationSpeed: CFTimeInterval = 0.3
    
    let startColor = UIColor.mood_startColor()
    let endColor = UIColor.mood_endColor()
    
    var firstAppearance = true
    var setup = false
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moodTrigger.delegate = self
        
        view.backgroundColor = UIColor.mood_blueColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterForeground", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstAppearance {
            firstAppearance = false
            createAndAddTouchPoint()
            createAndAddMoodCircle()
            
            contentView.transform = CGAffineTransformMakeScale(0.6, 0.6)
            contentView.alpha = 0.4
            
            createNewMood()
            
            setup = true
        }
    }
    
    private func createNewMood() {
        UIView.animateWithDuration(1.4, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.contentView.alpha = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
    }
    
    private func createAndAddTouchPoint() {
        let touchRadius: CGFloat = initialRadius - 4.0
        let touchRect: CGRect = CGRect(x: 0, y: 0, width: touchRadius * 2.0, height: touchRadius * 2.0)
        touchPoint.rasterizationScale = UIScreen.mainScreen().scale
        touchPoint.shouldRasterize = true
        touchPoint.frame = CGRect(x: 0, y: 0, width: touchRadius * 2.0, height: touchRadius * 2.0)
        touchPoint.position = CGPoint(x: view.center.x, y: contentView.center.y + 50)
        touchPoint.path = UIBezierPath(roundedRect: touchRect, cornerRadius: touchRadius).CGPath
        touchPoint.fillColor = UIColor.whiteColor().colorWithAlphaComponent(1.0).CGColor
        
        view.layer.addSublayer(touchPoint)
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
    
    func applicationDidEnterForeground() {
        if setup {
            addGrowAnimation()
        }
    }
    
    
    // MARK: MoodViewDelegate
    
    func moodViewTouchesBegan() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1 / 60, target: self, selector: "update", userInfo: nil, repeats: true)
        
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.touchPoint.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
            self.touchPoint.opacity = 0.5
            }) { (done: Bool) -> Void in
                return()
        }
    }
    
    func moodViewTouchesEnded() {
        timer?.invalidate()
        
        // bug: state doesnt get reset when app moves to background
        
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.touchPoint.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            self.touchPoint.opacity = 1.0
            }) { (done: Bool) -> Void in
                return()
        }
        
        UIView.animateWithDuration(0.6, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.contentView.transform = CGAffineTransformConcat(self.contentView.transform, CGAffineTransformMakeScale(0.1, 0.1))
            self.contentView.alpha = 0.8
            }) { (done: Bool) -> Void in
                self.circle.timeOffset = 0.0
                self.currentTime = 0.0
                self.createNewMood()
                
                let center = self.containerView.frame.origin.y + self.contentView.frame.origin.y + 40
                
                // draw check mark
                
                
//                let path = UIBezierPath()
//                path.moveToPoint(CGPoint(x: self.view.center.x - 6.0, y: center - 6))
//                path.addLineToPoint(CGPoint(x: self.view.center.x - 6.0, y: center - 6))
//                
//                let firstLine = UIBezierPath()
//                firstLine.moveToPoint(CGPoint(x: self.view.center.x - 6.0, y: center - 6))
//                firstLine.addLineToPoint(CGPoint(x: self.view.center.x, y: center))
//                
//                let secondLine = UIBezierPath()
//                secondLine.moveToPoint(CGPoint(x: self.view.center.x, y: center))
//                secondLine.addLineToPoint(CGPoint(x: self.view.center.x + 10.0, y: center - 12))
//                
//                let firstLineAnimation = CABasicAnimation(keyPath: "path")
//                firstLineAnimation.fromValue = path.CGPath
//                firstLineAnimation.toValue = firstLine.CGPath
//                firstLineAnimation.duration = 5.0
//                
//                let secondLineAnimation = CABasicAnimation(keyPath: "path")
//                secondLineAnimation.fromValue = firstLine.CGPath
//                secondLineAnimation.toValue = secondLine.CGPath
//                secondLineAnimation.duration = 5.0
//                secondLineAnimation.beginTime = 5.0
//
//                let animationGroup = CAAnimationGroup()
//                animationGroup.animations = [firstLineAnimation, secondLineAnimation]
//                
//                let shape = CAShapeLayer()
//                shape.path = path.CGPath
//                shape.strokeColor = UIColor.whiteColor().CGColor
//                shape.lineWidth = 3.0
//                shape.lineCap = kCALineCapRound
//                shape.fillColor = UIColor.clearColor().CGColor
//                self.view.layer.addSublayer(shape)
//                
//                shape.addAnimation(firstLineAnimation, forKey: "butts")
//                shape.addAnimation(secondLineAnimation, forKey: "bugga")
//                shape.path = otherPath.CGPath

                return()
        }
        
        UIView.animateWithDuration(1.0, animations: {
            self.view.backgroundColor = UIColor.mood_blueColor()
        })
    }
}
