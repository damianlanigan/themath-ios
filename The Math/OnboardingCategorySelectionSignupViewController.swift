//
//  OnboardingCategorySelectionSignupViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol OnboardingCategorySelectionSignupViewControllerDelegate {
    func userDidTapLoginButton()
    func userDidSignUp()
}

class OnboardingCategorySelectionSignupViewController: UIViewController, CategorySelectionViewControllerDelegate {

    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var categorySelectionContainer: UIView!
    
    @IBOutlet weak var signupContainer: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var delegate: OnboardingCategorySelectionSignupViewControllerDelegate?
    
    var laid = false
    
    // MARK: <CategorySelectionViewControllerDelegate>
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addViewControllers()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        UIView.animateWithDuration(0.3, animations: {
            self.backButton.alpha = 0.0
        })
        UIView.animateWithDuration(0.3, delay: 0.2, options: .CurveEaseOut, animations: {
            self.loginButton.alpha = 1.0
            }) { (done: Bool) -> Void in
        }
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        delegate?.userDidTapLoginButton()
    }
    
    func addViewControllers() {
        addCategorySelectionViewController()
        addSignupViewController()
        
        categorySelectionContainer.backgroundColor = UIColor.greenColor()
    }
    
    func addCategorySelectionViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: CategorySelectionViewController = storyboard.instantiateViewControllerWithIdentifier("CategorySelection") as CategorySelectionViewController
        viewController.delegate = self
        _addContentViewController(viewController, toView: categorySelectionContainer)
    }
    
    func addSignupViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: SignupViewController = storyboard.instantiateViewControllerWithIdentifier("SignupController") as SignupViewController
        _addContentViewController(viewController, toView: signupContainer)
    }
    
    override func viewDidLayoutSubviews() {
        if !laid {
            laid = true
            contentViewHeightConstraint.constant = view.frame.size.height
            contentViewWidthConstraint.constant = view.frame.size.width * 2.0
            scrollView.contentSize = CGSizeMake(contentViewHeightConstraint.constant, contentViewWidthConstraint.constant)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: <CategorySelectionViewControllerDelegate>
    
    func categorySelectionViewDidFinishSelectingCategories(categories: [CategoryType]) {
        scrollView.setContentOffset(CGPointMake(view.frame.size.width, 0), animated: true)
        
        UIView.animateWithDuration(0.3, animations: {
            self.loginButton.alpha = 0.0
        })
        UIView.animateWithDuration(0.3, delay: 0.2, options: .CurveEaseOut, animations: {
            self.backButton.alpha = 1.0
            }) { (done: Bool) -> Void in
        }    }
}
