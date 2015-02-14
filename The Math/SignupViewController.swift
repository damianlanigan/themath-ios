//
//  SignupViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class SignupViewController: AuthViewController {
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAccountButton.layer.cornerRadius = 6.0
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
   
    @IBAction func createAccountButtonTapped(sender: AnyObject) {
        println("create account")
    }

}
