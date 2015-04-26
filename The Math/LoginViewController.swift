//
//  LoginViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class LoginViewController: AuthViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var laid = false
    
    @IBAction func forgotPasswordButtonTapped(sender: UIButton) {
        println("forgot password button tapped")
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        let email = emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordField.text
        let params = ["email" : email, "password" : password, "grant_type" : "password"]
        Account.sharedAccount().login(params, callback: { (success, error) -> () in
            if let error = error {
                for (key, values) in error {
                    println(key)
                    for value in values {
                        println(" " + value)
                    }
                }
            } else if success {
                self.delegate?.userDidLogin?()
            }
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        
        loginButton.layer.cornerRadius = 6.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var string = NSMutableAttributedString(string: "Forgot your password? Reset Password")
        let regularFont = UIFont(name: "AvenirNext-Regular", size: 13)!
        let boldFont = UIFont(name: "AvenirNext-DemiBold", size: 13)!
        let regularRange = NSMakeRange(0, count("Forgot your password?"))
        let boldRange = NSMakeRange(regularRange.length, count(" Reset Password"))
        
        string.addAttributes([
            NSFontAttributeName : regularFont
            ], range: regularRange)
        
        string.addAttributes([
            NSFontAttributeName : boldFont
            ], range: boldRange)
        
        forgotPasswordButton.setAttributedTitle(string, forState: .Normal)
    }

    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
