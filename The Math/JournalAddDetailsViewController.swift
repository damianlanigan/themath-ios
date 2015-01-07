//
//  JournalAddDetailsViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 1/7/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol JournalAddDetailsViewControllerDelegate {
    
    // this should also contain the information that was saved,
    // optional photo data and some text
    
    func didSaveJournalDetails()
}

class JournalAddDetailsViewController: UIViewController {
    
    var delegate: JournalAddDetailsViewControllerDelegate?

    @IBOutlet weak var buttonContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailTextView: UITextView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        subscribeNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        detailTextView.becomeFirstResponder()
    }
    
    @IBAction func addPhotoButtonTapped(sender: AnyObject) {
        // show action sheet. take photo or select from library
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        detailTextView.resignFirstResponder()
        delegate?.didSaveJournalDetails()
    }
    
    private func subscribeNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo
        if let userInfo = info {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                if let animationDuration: Double = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSValue)? as? Double {
                    
                    let height = keyboardSize.size.height
                    buttonContainerBottomConstraint.constant = height
                    
                    UIView.animateWithDuration(animationDuration, animations: {
                        self.view.layoutIfNeeded()
                    })
                    
                }
            }
        }

    }
    
    func keyboardWillHide(notification: NSNotification) {
        
    }
}
