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
    
    @IBAction func createAccountButtonTapped(sender: AnyObject) {
        let email = emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordField.text
        
        let params = ["signup" : ["email" : email, "password" : password]]
        request(Router.SignupAccount(params)).responseJSON { (request, response, data, error) in
            println(data)
        }
        
//        delegate?.userDidSignup?()
    }

}
