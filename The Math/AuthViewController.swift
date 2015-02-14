//
//  AuthViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

@objc protocol AuthViewControllerDelegate {
    optional func userDidLogin()
    optional func userDidSignup()
}

class AuthViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: AuthViewControllerDelegate?
    
    var focusedTextField: UITextField?
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    // MARK: <UITextFieldDelegate>
    
    func textFieldDidBeginEditing(textField: UITextField) {
        focusedTextField = textField
        println(focusedTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let textField = focusedTextField {
            if textField == emailField {
                passwordField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                focusedTextField = nil
            }
        }
        return true
    }
}
