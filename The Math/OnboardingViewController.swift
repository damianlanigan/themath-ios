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
    UIAlertViewDelegate,
    AuthViewControllerDelegate {
    
    private enum OnboardingViewsNibNames: String {
        case MoodView = "OnboardingMoodView"
        case JournalView = "OnboardingJournalView"
        case ReflectView = "OnboardingReflectView"
        case SignupView = "OnboardingSignupView"
        case LocationView = "OnboardingLocationView"
    }
    
    let numberOfPages: CGFloat = 2.0
    lazy var numberOfSubPages: CGFloat = {
        return CGFloat(self.onboardingViews.count + 1)
    }()
    
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
        
        setupNotificationObservers()
        
        loadSubContentOnboardingViews()
        subScrollView.delegate = self
        
        if subScrollView.contentOffset.y == view.frame.size.height * 3.0 {
            if LocationCoordinator.authorizationNotDetermined() {
                subScrollView.setContentOffset(CGPointMake(0.0, view.frame.size.height * 3.0), animated: true)
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var onboardingViews: [UIView] = {
        var views: [UIView] = [
            UIView.viewFromNib(OnboardingViewsNibNames.MoodView.rawValue),
            UIView.viewFromNib(OnboardingViewsNibNames.JournalView.rawValue),
            UIView.viewFromNib(OnboardingViewsNibNames.ReflectView.rawValue)
        ]
        
        if (!LocationCoordinator.isActive()) {
            views.append(UIView.viewFromNib(OnboardingViewsNibNames.LocationView.rawValue))
        }
        
        return views
    }()
    
    private func loadSubContentOnboardingViews() {
        
        subContentView.backgroundColor = UIColor.onboardingBackgroundColor()
        
        for (idx, view) in onboardingViews.enumerate() {
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
        signupViewController.view.frame.origin.y += view.frame.size.height * (numberOfSubPages - 1)
    }
    
    private func layoutDots() {
        let dots = [
            UIImageView(image: UIImage(named: "dots_light")!),
            UIImageView(image: UIImage(named: "dots_medium")!),
            UIImageView(image: UIImage(named: "dots_dark")!)
        ]
        
        for (idx, image) in dots.enumerate() {
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
        if LocationCoordinator.isInactive() {
            LocationCoordinator.activate()
            scrollToSignup()
        } else if LocationCoordinator.isActive() {
            scrollToSignup()
        } else if LocationCoordinator.needsRequestAuthorization() {
            print("starting or requesting permissions")
            LocationCoordinator.activate()
            LocationCoordinator.sharedCoordinator.requestAuthorization()
        } else {
            LocationCoordinator.deactivate()
            let alert = UIAlertView(title: "Location Permissions", message: "You need to go to settings", delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles:"Settings")
            alert.show()
        }
    }
    
    private func scrollToSignup() {
        let y = (numberOfSubPages - 1) * view.frame.size.height
        subScrollView.setContentOffset(CGPointMake(0.0, y), animated: true)
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
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    // MARK: UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.navigateToSettings()
        }
    }
    
}
