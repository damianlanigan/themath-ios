//
//  InfographViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 1/30/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class InfographViewController: UIViewController {

    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    private let numberOfScreens: CGFloat = 3.0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        contentViewHeightConstraint.constant = view.frame.size.height
        contentViewWidthConstraint.constant = view.frame.size.width * numberOfScreens
    }
}
