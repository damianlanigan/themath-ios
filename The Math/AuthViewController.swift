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

class AuthViewController: UITableViewController,
    UITextFieldDelegate {

    weak var delegate: AuthViewControllerDelegate?
    
    var focusedTextField: UITextField?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        
        emailField.delegate = self
        passwordField.delegate = self
        
    }
    
    func cancel() {
        focusedTextField?.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: <UITextFieldDelegate>
    
    func textFieldDidBeginEditing(textField: UITextField) {
        focusedTextField = textField
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

