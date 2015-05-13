//
//  OnboardingViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 1/28/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func didFinishOnboarding(viewController: OnboardingViewController)
}

class OnboardingViewController: UIViewController,
    UIScrollViewDelegate,
    AuthViewControllerDelegate {
    
    let numberOfPages: CGFloat = 2.0
    let numberOfSubPages: CGFloat = 5.0
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subContentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var subContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subScrollView: UIScrollView!
    
    @IBOutlet weak var parallaxImageContainerView: UIView!
    @IBOutlet weak var newUserButton: UIButton!
    
    var firstAppearance = true
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutScrollView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollView.delegate = self
        
        if firstAppearance {
            firstAppearance = false
            layoutDots()
        }
    }
    
    private func layoutDots() {
        let dots = [
            UIImageView(image: UIImage(named: "dots_light")!),
            UIImageView(image: UIImage(named: "dots_medium")!),
            UIImageView(image: UIImage(named: "dots_dark")!)
        ]
        
        for (idx, image) in enumerate(dots) {
            let offset = (idx * 16) + 1
            let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
            xAxis.minimumRelativeValue = -offset
            xAxis.maximumRelativeValue = offset
            
            let yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
            yAxis.minimumRelativeValue = -offset
            yAxis.maximumRelativeValue = offset
            
            let group = UIMotionEffectGroup()
            group.motionEffects = [xAxis, yAxis]
         
            image.addMotionEffect(group)
            image.center = view.center
            
            parallaxImageContainerView.addSubview(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navController = segue.destinationViewController as? UINavigationController {
            if let viewController = navController.viewControllers[0] as? LoginViewController {
                viewController.delegate = self
            } else if let viewController = navController.viewControllers[0] as? SignupViewController {
                viewController.delegate = self
            }
        }
    }
    
    @IBAction func getStartedButtonTapped(sender: AnyObject) {
        delegate?.didFinishOnboarding(self)
    }
    
    private func activateOnboarding() {
        scrollView.scrollEnabled = true
        scrollView.setContentOffset(CGPointMake(0.0, view.frame.size.height), animated: true)
    }
    
    private func layoutScrollView() {
        contentViewWidthConstraint.constant = view.frame.size.width
        contentViewHeightConstraint.constant = view.frame.size.height * numberOfPages
        subContentViewWidthConstraint.constant = view.frame.size.width
        subContentViewHeightConstraint.constant = view.frame.size.height * numberOfSubPages
        
        scrollView.contentSize = CGSizeMake(view.frame.size.width, contentViewHeightConstraint.constant)
        subScrollView.contentSize = CGSizeMake(view.frame.size.width, subContentViewHeightConstraint.constant)
    }
    
    // MARK: <UIScrollViewDelegate>
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.scrollView && scrollView.contentOffset.y == 0 {
            scrollView.scrollEnabled = false
        }
    }
    
    // MARK: <AuthViewControllerDelegate>
    
    func userDidLogin() {
        delegate?.didFinishOnboarding(self)
    }
    
    func userDidSignup() {
        delegate?.didFinishOnboarding(self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
}
