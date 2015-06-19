//
//  SignupViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import SwiftLoader

class SignupViewController: AuthViewController {
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.949, green:0.980, blue:0.988, alpha: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAccountButton.layer.cornerRadius = 6.0
    }
    
    @IBAction func createAccountButtonTapped(sender: AnyObject) {
        // TODO: validation?
        
        let email = emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordField.text
        
        let params = ["signup" : ["email" : email, "password" : password]]
        
        
        SwiftLoader.show(animated: true)
        Account.sharedAccount().signup(params, callback: { (success, error) -> () in
            var message = ""
            if let error = error {
                for (key, values) in error {
                    message += key + "\n"
                    for value in values {
                        message += " " + value + "\n"
                    }
                }
                SwiftLoader.hide()
                let alert = UIAlertView(title: "Something's wrong", message: message, delegate: nil, cancelButtonTitle: "Dismiss")
                alert.show()
            } else if success {
                SwiftLoader.hide()
                self.delegate?.userDidSignup?()
            }
        })
    }
}
