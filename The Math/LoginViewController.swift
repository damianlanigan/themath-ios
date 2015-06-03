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
            if success {
                self.delegate?.userDidLogin?()
            } else {
                let alert = UIAlertView(title: "Something's wrong", message: "The username or password you entered is incorrect", delegate: nil, cancelButtonTitle: "Dismiss")
                alert.show()
            }
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
