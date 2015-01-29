//
//  OnboardingViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 1/28/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate  {
    func didFinishOnboarding()
}

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    let numberOfPages: CGFloat = 6.0
    
    var delegate: OnboardingViewControllerDelegate?

    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        contentViewWidthConstraint.constant = view.frame.size.width
        contentViewHeightConstraint.constant = view.frame.size.height * numberOfPages
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height * numberOfPages)
    }
    
    // MARK: <UIScrollViewDelegate>
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > view.frame.size.height * numberOfPages {
            
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + view.frame.size.height > view.frame.size.height * numberOfPages {
            delegate?.didFinishOnboarding()
        }
    }
    
}
