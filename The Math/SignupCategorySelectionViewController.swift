//
//  SignupCategorySelectionViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/14/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class SignupCategorySelectionViewController: UIViewController,
    AuthViewControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupContainerView: UIView!
    @IBOutlet weak var categorySelectionContainerView: UIView!
    
    var signupController: SignupViewController?
    
    var laid = false
    
    weak var delegate: AuthViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Categories"
    }
    
    override func viewDidLayoutSubviews() {
        if !laid {
            laid = true
            
            addSignupViewController()

            contentViewHeightConstraint.constant = view.frame.size.height
            contentViewWidthConstraint.constant = view.frame.size.width * 2.0
            
            scrollView.contentSize = CGSizeMake(contentViewWidthConstraint.constant, contentViewHeightConstraint.constant)
        }
    }
    
    private func addSignupViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        signupController = storyboard.instantiateViewControllerWithIdentifier("SignupController") as? SignupViewController
        signupController?.delegate = self
        _addContentViewController(signupController!, toView: signupContainerView)
    }
    
    private func navigateToSignUp() {
        scrollView.setContentOffset(CGPointMake(view.frame.size.width, 0), animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "navigateToCategories")
        navigationItem.title = "Create account"
    }
    
    func navigateToCategories() {
        signupController!.focusedTextField?.resignFirstResponder()
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
