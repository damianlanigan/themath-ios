//
//  SignupCategorySelectionViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/14/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class SignupCategorySelectionViewController: UIViewController,
    CategorySelectionViewControllerDelegate,
    AuthViewControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupContainerView: UIView!
    @IBOutlet weak var categorySelectionContainerView: UIView!
    
    var signupController: SignupViewController?
    
    var laid = false
    
    weak var delegate: AuthViewControllerDelegate?
    
    deinit {
        println("bye !!!!!!!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Categories"
    }
    
    override func viewDidLayoutSubviews() {
        if !laid {
            laid = true
            
            addSignupViewController()
            addCategorySelectionViewController()

            contentViewHeightConstraint.constant = view.frame.size.height
            contentViewWidthConstraint.constant = view.frame.size.width * 2.0
            
            scrollView.contentSize = CGSizeMake(contentViewWidthConstraint.constant, contentViewHeightConstraint.constant)
        }
    }
    
    private func addCategorySelectionViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("CategorySelection") as CategorySelectionViewController
        viewController.delegate = self
        _addContentViewController(viewController, toView: categorySelectionContainerView)
    }
    
    private func addSignupViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignupController") as SignupViewController
        viewController.delegate = self
        _addContentViewController(viewController, toView: signupContainerView)
    }
    
    private func navigateToSignUp() {
        scrollView.setContentOffset(CGPointMake(view.frame.size.width, 0), animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "navigateToCategories")
        navigationItem.title = "Create account"
    }
    
    func navigateToCategories() {
//        signupController!.focusedTextField?.resignFirstResponder()
        scrollView.setContentOffset(CGPointZero, animated: true)
        navigationItem.leftBarButtonItem = nil
        navigationItem.title = "Categories"
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: <CategorySelectionViewController>
    
    func categorySelectionViewDidFinishSelectingCategories(categories: [CategoryType]) {
        navigateToSignUp()
    }
    
    // MARK: <SignupViewControllerDelegate>
    
    func userDidSignup() {
        delegate?.userDidSignup?()
    }
}
