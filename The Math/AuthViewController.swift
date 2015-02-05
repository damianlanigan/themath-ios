//
//  AuthViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/5/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol AuthViewControllerDelegate {
    func userDidLogin()
    func userDidSignup()
}

class AuthViewController: UIViewController {

    var delegate: AuthViewControllerDelegate?
    
}
