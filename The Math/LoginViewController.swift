//
//  LoginViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import SwiftLoader

class LoginViewController: AuthViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var laid = false

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loginButton.layer.cornerRadius = 6.0
        emailField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let string = NSMutableAttributedString(string: "Forgot your password? Reset Password")
        let regularFont = UIFont(name: "AvenirNext-Regular", size: 13)!
        let boldFont = UIFont(name: "AvenirNext-DemiBold", size: 13)!
        let regularRange = NSMakeRange(0, "Forgot your password?".characters.count)
        let boldRange = NSMakeRange(regularRange.length, " Reset Password".characters.count)
        
        string.addAttributes([
            NSFontAttributeName : regularFont
            ], range: regularRange)
        
        string.addAttributes([
            NSFontAttributeName : boldFont
            ], range: boldRange)
        
        forgotPasswordButton.setAttributedTitle(string, forState: .Normal)
    }
    
    
    @IBAction func forgotPasswordButtonTapped(sender: UIButton) {
        let email = emailField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if email.isEmpty {
            let alert = UIAlertView(title: "Email address", message: "Enter the email address for your account", delegate: nil, cancelButtonTitle: "Dismiss")
            alert.show()
        } else {
            Account.currentUser().requestPasswordReset(email) { (success) in
                if success {
                    let alert = UIAlertView(title: "Reset password", message: "You will receive an email with instructions to reset your password.", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
        }
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        let email = emailField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordField.text!
        let params = ["email" : email, "password" : password, "grant_type" : "password"]
        
        SwiftLoader.show(animated: true);
        Account.sharedAccount().login(params, callback: { (success) -> () in
            if success {
                SwiftLoader.hide()
                self.delegate?.userDidLogin?()
            } else {
                SwiftLoader.hide()
                let alert = UIAlertView(title: "Something's wrong", message: "The email or password is incorrect", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
