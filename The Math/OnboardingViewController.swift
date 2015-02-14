//
//  OnboardingViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 1/28/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate {
    func didFinishOnboarding(viewController: OnboardingViewController)
}

class OnboardingViewController: GAITrackedViewController,
    CategorySelectionViewControllerDelegate,
    UIScrollViewDelegate {
    
    let numberOfPages: CGFloat = 2.0
    let numberOfSubPages: CGFloat = 5.0
    
    var delegate: OnboardingViewControllerDelegate?
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subContentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var subContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subScrollView: UIScrollView!
    
    @IBOutlet weak var newUserButton: UIButton!
    
    var laid = false
    
    override func viewDidLayoutSubviews() {
        if !laid {
            laid = true
            layoutScrollView()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        screenName = "Onboarding"
        
        newUserButton.layer.cornerRadius = 6.0
        newUserButton.layer.borderWidth = 2.0
        newUserButton.layer.borderColor = UIColor.whiteColor().CGColor
    }

    @IBAction func selectCategoriesButtonTapped(sender: AnyObject) {
        showCategorySelectionViewController()
    }
    
    @IBAction func existingUserButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func newUserButtonTapped(sender: AnyObject) {
        activateOnboarding()
    }
    
    private func activateOnboarding() {
        scrollView.setContentOffset(CGPointMake(0.0, view.frame.size.height), animated: true)
        scrollView.scrollEnabled = true
    }
    
    private func layoutScrollView() {
        contentViewWidthConstraint.constant = view.frame.size.width
        contentViewHeightConstraint.constant = view.frame.size.height * numberOfPages
        subContentViewWidthConstraint.constant = view.frame.size.width
        subContentViewHeightConstraint.constant = view.frame.size.height * numberOfSubPages
        
        scrollView.contentSize = CGSizeMake(view.frame.size.width, contentViewHeightConstraint.constant)
        subScrollView.contentSize = CGSizeMake(view.frame.size.width, subContentViewHeightConstraint.constant)
        
        scrollView.delegate = self
    }
    
    private func showCategorySelectionViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("CategorySelection") as? CategorySelectionViewController
        viewController?.delegate = self
        presentViewController(viewController!, animated: true, completion: nil)
    }
    
    func categorySelectionViewDidFinishSelectingCategories(categories: [CategoryType]) {
        delegate?.didFinishOnboarding(self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: <UIScrollViewDelegate>
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.scrollView && scrollView.contentOffset.y == 0 {
            scrollView.scrollEnabled = false
        }
    }
    
}
