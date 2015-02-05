//
//  OnboardingCategorySelectionSignupViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class OnboardingCategorySelectionSignupViewController: UIViewController, CategorySelectionViewControllerDelegate {

    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var categorySelectionContainer: UIView!
    
    @IBOutlet weak var signupContainer: UIView!
    
    var laid = false
    
    // MARK: <CategorySelectionViewControllerDelegate>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewControllers()
    }
    
    func addViewControllers() {
        addCategorySelectionViewController()
    }
    
    func addCategorySelectionViewController() {
        
    }
    
    override func viewDidLayoutSubviews() {
        if !laid {
            laid = true
            contentViewHeightConstraint.constant = view.frame.size.height
            contentViewWidthConstraint.constant = view.frame.size.width * 2.0
            scrollView.contentSize = CGSizeMake(contentViewHeightConstraint.constant, contentViewWidthConstraint.constant)
        }
    }
    
    func categorySelectionViewDidFinishSelectingCategories(categories: [CategoryType]) {
        
    }
}
