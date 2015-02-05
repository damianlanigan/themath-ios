//
//  OnboardingViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 1/28/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate {
    func didFinishOnboarding()
    func didTapLoginButton()
}

class OnboardingViewController: UIViewController, CategorySelectionViewControllerDelegate {
    
    let numberOfPages: CGFloat = 6.0
    
    var delegate: OnboardingViewControllerDelegate?
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var laid = false
    
    var tableOffset: CGFloat = 0.0
    
    override func viewDidLayoutSubviews() {
        if !laid {
            laid = true
            layoutScrollView()
        }
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        delegate?.didTapLoginButton()
    }
    
    private func layoutScrollView() {
        contentViewWidthConstraint.constant = view.frame.size.width
        contentViewHeightConstraint.constant = view.frame.size.height * numberOfPages
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height * numberOfPages)
    }
    
    private func showCategorySelectionViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("CategorySelection") as? CategorySelectionViewController
        viewController?.delegate = self
        presentViewController(viewController!, animated: true, completion: nil)
    }
    
    @IBAction func selectCategoriesButtonTapped(sender: AnyObject) {
        showCategorySelectionViewController()
    }
    
    // MARK: <CategorySelectionViewControllerDelegate>
    
    func categorySelectionViewDidFinishSelectingCategories(categories: [CategoryType]) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.didFinishOnboarding()
    }
    
}
