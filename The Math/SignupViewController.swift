//
//  SignupViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import SwiftLoader
import TTTAttributedLabel

class SignupViewController: AuthViewController,
    TTTAttributedLabelDelegate {
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var subtextLabel: TTTAttributedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.949, green:0.980, blue:0.988, alpha: 1)
        
        setupTTTAttributedLabel()
        
    }
    
    func setupTTTAttributedLabel() {
        let str = subtextLabel.text!
        let NSStr = NSString(format: "%@", str)
        let font = UIFont(name: CabritoSansFontName, size: subtextLabel.font.pointSize)!
        let attrStr = NSMutableAttributedString(string: str)
        let strRange = NSMakeRange(0, count(str))
        attrStr.addAttribute(NSFontAttributeName, value: font, range: strRange)
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: strRange)
        
        let privacyRange = NSStr.rangeOfString("Privacy Policy")
        let termsRange = NSStr.rangeOfString("Terms of Service")
        
        let boldFont = UIFont(name: "AvenirNext-DemiBold", size: subtextLabel.font.pointSize)!
        attrStr.addAttribute(NSFontAttributeName, value: boldFont, range: privacyRange)
        attrStr.addAttribute(NSFontAttributeName, value: boldFont, range: termsRange)
        
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: privacyRange)
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: termsRange)
        
        subtextLabel.addLinkToURL(NSURL(string: "http://howamidoingapp.com/privacy")!, withRange: privacyRange)
        subtextLabel.addLinkToURL(NSURL(string: "http://howamidoingapp.com/terms")!, withRange: termsRange)
        
        subtextLabel.attributedText = attrStr
        subtextLabel.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAccountButton.layer.cornerRadius = 6.0
    }
    
    func hideKeyboard() {
        focusedTextField?.resignFirstResponder()
        focusedTextField = nil
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
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let viewController = WebViewController()
        viewController.url = url
        viewController.navigationTitle = "Privacy/TOS"
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [viewController];
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
}
