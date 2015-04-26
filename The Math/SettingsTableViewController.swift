//
//  SettingsTableViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/24/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate: class {
    func didLogout()
}

class SettingsTableViewController: UITableViewController {
    
    weak var delegate: SettingsTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        let button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
        navigationItem.leftBarButtonItem = button
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            Account.sharedAccount().logout({
                println("logged out")
                self.delegate?.didLogout()
            })
        }
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
