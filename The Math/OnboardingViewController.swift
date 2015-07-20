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
    
    private enum OnboardingViewsNibNames: String {
        case MoodView = "OnboardingMoodView"
        case JournalView = "OnboardingJournalView"
        case ReflectView = "OnboardingReflectView"
        case SignupView = "OnboardingSignupView"
        case LocationView = "OnboardingLocationView"
    }
    
    let numberOfPages: CGFloat = 2.0
    let numberOfSubPages: CGFloat = 5.0
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subContentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var subContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subScrollView: UIScrollView!
    @IBOutlet weak var subContentView: UIView!
    
    @IBOutlet weak var parallaxImageContainerView: UIView!
    @IBOutlet weak var newUserButton: UIButton!
    
    var firstAppearance = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = -14
        xAxis.maximumRelativeValue = 14
        
        let yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = -14
        yAxis.maximumRelativeValue = 14
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xAxis, yAxis]
        
        view.addMotionEffect(group)
    }
    
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadSubContentOnboardingViews()
        subScrollView.delegate = self
        
        if subScrollView.contentOffset.y == view.frame.size.height * 3.0 {
            if LocationCoordinator.authorizationNotDetermined() {
                subScrollView.setContentOffset(CGPointMake(0.0, view.frame.size.height * 3.0), animated: true)
            }
        }
    }
    
    private func onboardingViews() -> [UIView] {
        return [
            UIView.viewFromNib(OnboardingViewsNibNames.MoodView.rawValue),
            UIView.viewFromNib(OnboardingViewsNibNames.JournalView.rawValue),
            UIView.viewFromNib(OnboardingViewsNibNames.ReflectView.rawValue),
            UIView.viewFromNib(OnboardingViewsNibNames.LocationView.rawValue)
        ]
    }
    
    private func loadSubContentOnboardingViews() {
        
        subContentView.backgroundColor = UIColor.onboardingBackgroundColor()
        
        for (idx, view) in enumerate(onboardingViews()) {
            view.frame = self.view.bounds
            subContentView.addSubview(view)
            view.frame.origin.y += self.view.frame.size.height * CGFloat(idx)
            
            if let locationView = view as? OnboardingLocationView {
                // horrible
                locationView.allowLocationButton.addTarget(self, action: "setupLocationServices", forControlEvents: .TouchUpInside)
            }
        }
        
        let signupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignupController") as! SignupViewController
        signupViewController.delegate = self
        _addContentViewController(signupViewController)
        subContentView.addSubview(signupViewController.view)
        signupViewController.view.frame = view.bounds
        signupViewController.view.frame.origin.y += view.frame.size.height * 4.0
    }
    
    private func layoutDots() {
        let dots = [
            UIImageView(image: UIImage(named: "dots_light")!),
            UIImageView(image: UIImage(named: "dots_medium")!),
            UIImageView(image: UIImage(named: "dots_dark")!)
        ]
        
        for (idx, image) in enumerate(dots) {
            let offset = (idx * 16) + 6
            
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
    
    private func setupNotificationObservers() {
        // THIS HAPPENS WHEN LOCATION PERMISSIONS ARE DETERMINED
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    // This is the only method that needs to be called 
    // in order to enable location on posts. This method
    // will request authorization if needed and start
    // updating locations. It will do nothing if permissions
    // are turned off
    func setupLocationServices() {
        if LocationCoordinator.isActive() {
            let y = 4.0 * view.frame.size.height
            subScrollView.setContentOffset(CGPointMake(0.0, y), animated: true)
        } else if LocationCoordinator.needsRequestAuthorization() {
            println("starting or requesting permissions")
            LocationCoordinator.activate()
            LocationCoordinator.sharedCoordinator.requestAuthorization()
        } else {
            LocationCoordinator.deactivate()
            println("we don't have location permissions")
        }
    }
    
    // MARK: Notifications
    
    func applicationDidBecomeActive() {
        setupLocationServices()
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
    
    func signupButtonTapped() {
        performSegueWithIdentifier("ShowSignupSegue", sender: self)
    }
    
    @IBAction func getStartedButtonTapped(sender: AnyObject) {
//        delegate?.didFinishOnboarding(self)
        activateOnboarding()
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
    
    lazy var lastOffset: CGFloat = {
        return self.view.frame.size.height * (self.numberOfSubPages - 1)
    }()
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == subScrollView {
            if subScrollView.contentOffset.y < lastOffset && subScrollView.contentOffset.y > lastOffset - 20 {
                if let viewController = childViewControllers.first as? SignupViewController {
                    viewController.hideKeyboard()
                }
            }
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
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
}
