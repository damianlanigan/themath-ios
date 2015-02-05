//
//  LoginViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class LoginViewController: AuthViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
   
    @IBAction func forgotPasswordButtonTapped(sender: UIButton) {
        println("forgot password button tapped")
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        delegate?.userDidLogin()
    }
}
